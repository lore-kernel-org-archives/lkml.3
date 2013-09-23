Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752864Ab3IWQnJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 12:43:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43649 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752448Ab3IWQnG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 12:43:06 -0400
Date: Mon, 23 Sep 2013 12:38:28 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: linux-audit@redhat.com, linux-kernel@vger.kernel.org
Cc: Steve Grubb <sgrubb@redhat.com>, Eric Paris <eparis@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 7/8] audit: clean up AUDIT_GET/SET local variables and
 future-proof API
Message-ID: <20130923163828.GT13968@madcap2.tricolour.ca>
References: <20130917152842.51158606ed46ec67b97b4448@linux-foundation.org>
 <3c8ba778c317db8e9d49fa44af736f4b122e4d06.1379530867.git.rgb@redhat.com>
 <1557446.mvTTyrtVjc@x2>
 <1379688470.5434.4.camel@flatline.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379688470.5434.4.camel@flatline.rdu.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 20, 2013 at 10:47:50AM -0400, Eric Paris wrote:
> On Thu, 2013-09-19 at 17:18 -0400, Steve Grubb wrote:
> > On Wednesday, September 18, 2013 03:06:52 PM Richard Guy Briggs wrote:
> > > Re-named confusing local variable names (status_set and status_get didn't
> > > agree with their command type name) and reduced their scope.
> > > 
> > > Future-proof API changes by not depending on the exact size of the
> > > audit_status struct.

> > Also, because there is no way to query the kernel to see what kind of things 
> > it supports
> 
> I'll agree.  Richard, can you please add a version field to the status?
> Start at version 1.  Any time we add a new audit feature we'll bump it.

Done.  Adding the interface and version field is version 1, so without,
it is zero.  Adding the backlog timeout is version 2.

- RGB

--
Richard Guy Briggs <rbriggs@redhat.com>
Senior Software Engineer
Kernel Security
AMER ENG Base Operating Systems
Remote, Ottawa, Canada
Voice: +1.647.777.2635
Internal: (81) 32635
Alt: +1.613.693.0684x3545
