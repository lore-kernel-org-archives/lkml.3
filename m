Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756957Ab3A3UtY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 15:49:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31270 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755169Ab3A3UtW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 15:49:22 -0500
Date: Wed, 30 Jan 2013 15:49:18 -0500
From: Aristeu Rozanski <aris@redhat.com>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Serge Hallyn <serge.hallyn@canonical.com>
Subject: Re: [PATCH v4 8/9] devcg: refactor dev_exception_clean()
Message-ID: <20130130204917.GL17632@redhat.com>
References: <20130130171101.060853036@napanee.usersys.redhat.com>
 <20130130171102.253395279@napanee.usersys.redhat.com>
 <20130130204730.GF8507@mail.hallyn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130130204730.GF8507@mail.hallyn.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 30, 2013 at 08:47:30PM +0000, Serge E. Hallyn wrote:
> Quoting aris@redhat.com (aris@redhat.com):
> > -
> > -			if (rc)
> > -				return rc;
> 
> Was this intentional?
> 
> I see that you next add
> 
> 	rc = propagate_behavior(devcgroup);
> 
> right here, but this means you're ignoring failure in the
> dev_exceptions_copy() call above.

that's not intentional. thanks for catching this

Tejun, you want me to resubmit the whole series or just the next patch
(where I was supposed to move that chunk)?

-- 
Aristeu

