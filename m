Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751562AbaFXEle (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 00:41:34 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:38720 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751155AbaFXEld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 00:41:33 -0400
Message-ID: <1403584890.3140.18.camel@dabdike>
Subject: Re: [RFC] Tux3 for review
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Daniel Phillips <daniel@phunq.net>
Cc: Pavel Machek <pavel@ucw.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org
Date: Tue, 24 Jun 2014 00:41:30 -0400
In-Reply-To: <522aee97-34e7-4adc-adf2-c9b73aa0ef36@phunq.net>
References: <5376B273.7000800@partner.samsung.com>
	 <20140518235555.GC18954@dastard> <537AA802.408@phunq.net>
	 <20140520031802.GF18954@dastard> <20140613103216.GA4589@amd.pavel.ucw.cz>
	 <02d3b094-808c-4b17-903d-1280d451704b@phunq.net>
	 <20140613202039.GA23872@amd.pavel.ucw.cz>
	 <b67e55e1-af54-4f34-802c-95749771aca4@phunq.net>
	 <1402932354.2197.61.camel@dabdike.int.hansenpartnership.com>
	 <20140619082129.GA4309@xo-6d-61-c0.localdomain>
	 <alpine.LFD.2.00.1406191117240.2182@localhost.localdomain>
	 <ad0baf8f-091f-45d0-8d9f-f72d78d0d1ff@phunq.net>
	 <1403378941.2177.24.camel@dabdike.int.hansenpartnership.com>
	 <e475a747-2f33-4c43-b6bd-98df2e57099a@phunq.net>
	 <1403448187.1949.9.camel@jarvis.lan>
	 <522aee97-34e7-4adc-adf2-c9b73aa0ef36@phunq.net>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.12.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-06-23 at 17:27 -0700, Daniel Phillips wrote:
> On Sunday, June 22, 2014 7:43:07 AM PDT, James Bottomley wrote:
> > On Sat, 2014-06-21 at 20:32 -0700, Daniel Phillips wrote:
> >> On Saturday, June 21, 2014 12:29:01 PM PDT, James Bottomley wrote:
> >>> That's a bit disingenuous: the concern has always been how page forking
> >>> interacted with writeback.  It's not new, it was one of the major 
> things
> >>> brought up at LSF 14 months ago, so you weren't just assigned this.
> >  ...
> >> 
> >> [citation needed]
> >
> > Really?  I was there; I remember and it's in my notes of the discussion.
> > However, it's also in Jon's at paragraph 6 if you need to refer to
> > something to refresh your memory.
> 
> You have such a wonderfully charismatic way of providing citations.

Well, it's factual, as I presume you have now discovered.

> > However, when it was spotted isn't the issue; how we add tux3 without a
> > large maintenance burden on writeback is, as I carefully explained in
> > the rest of the email you cut.
> 
> You are doing a fine job of proving to the world that LKML has become
> a toxic waste dump. CC to LKML removed for obvious reasons.

Please don't drop the Mailing list cc; that's where the debate actually
happens and where others can see it.

>  Please let this be the end of the unhelpful rhetoric that does none of us any
> good, especially you.

Telling you factually what the issue is isn't rhetoric.  Your Ad Hominem
reply, of course, is rhetoric but I don't need to bother engaging with
your rhetorical technique because I'm still arguing the facts: proving
that page forking can be integrated into writeback without adding to the
maintenance burden is a big issue for tux3.  We're all still waiting for
the patches you were going to produce showing how this could be done.

James


