Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755753Ab3EVKCV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 06:02:21 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:44902 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753314Ab3EVKCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 06:02:18 -0400
Date: Wed, 22 May 2013 19:02:12 +0900
From: Tejun Heo <tj@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: PING^7 (was Re: [PATCH v2 00/14] Corrections and customization
 of the SG_IO command whitelist (CVE-2012-4542))
Message-ID: <20130522100212.GE3466@mtj.dyndns.org>
References: <1360163761-8541-1-git-send-email-pbonzini@redhat.com>
 <519C674A.50700@redhat.com>
 <20130522093249.GC3466@mtj.dyndns.org>
 <519C959A.3090100@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <519C959A.3090100@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 22, 2013 at 11:53:30AM +0200, Paolo Bonzini wrote:
> Il 22/05/2013 11:32, Tejun Heo ha scritto:
> > On Wed, May 22, 2013 at 08:35:54AM +0200, Paolo Bonzini wrote:
> >> I'm not sure what is more ridiculous, whether the seven pings or the
> >> lack of review...
> > 
> > So, ummm, I don't know what Jens is thinking but at this point I'm
> > basically waiting for someone else to pick it up as review to return
> > ratio is too low to continue.  It doesn't seem like I can get the
> > series into a shape I can ack with reasonable amount of effort.
> 
> Then please say so.  I didn't find any comment in your review that I missed.

Well, I've tried that multiple times and didn't get the results that I
was expecting each time, so doing it all over again felt pointless.
Even now, you just repeat what you've been saying and I'd have to
fight through each and every point.  It just doesn't feel worth the
effort.  It'd be far less effort to just slurp the patches and
regurgitate them myself.  I don't care that much about the changes
right now, so I'm just waiting for either someone else picking it up
or my yield with you somehow magically improving and the next refresh
addressing most of the issues.

So, I suppose this is bye bye at least on this thread.

-- 
tejun
