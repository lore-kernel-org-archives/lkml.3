Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162132Ab3DEQx3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 12:53:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25827 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162077Ab3DEQx3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 12:53:29 -0400
Subject: Re: GFS2: Pull request (fixes)
From: Steven Whitehouse <swhiteho@redhat.com>
To: David Teigland <teigland@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, cluster-devel@redhat.com
In-Reply-To: <20130405162746.GD20835@redhat.com>
References: <1365158085.2735.25.camel@menhir>
	 <20130405162746.GD20835@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Fri, 05 Apr 2013 17:51:16 +0100
Message-ID: <1365180676.2735.26.camel@menhir>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, 2013-04-05 at 12:27 -0400, David Teigland wrote:
> On Fri, Apr 05, 2013 at 11:34:45AM +0100, Steven Whitehouse wrote:
> > Please consider pulling the following changes,
> 
> There's some mixup here that should be cleared up first.
> 
> > David Teigland (2):
> >       GFS2: Fix unlock of fcntl locks during withdrawn state
> > 
> > Steven Whitehouse (1):
> >       GFS2: Fix unlock of fcntl locks during withdrawn state
> 
> 

Yes, sorry about that. I'll fix that up and resend the pull request in
due course,

Steve.


