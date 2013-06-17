Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283Ab3FQSCY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 14:02:24 -0400
Received: from guitar.tcltek.co.il ([192.115.133.116]:53413 "EHLO
	sivan.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753709Ab3FQSCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 14:02:20 -0400
Date: Mon, 17 Jun 2013 21:02:11 +0300
From: Baruch Siach <baruch@tkos.co.il>
To: John Stultz <john.stultz@linaro.org>
Cc: Will Deacon <will.deacon@arm.com>, Russell King <linux@arm.linux.org.uk>,
        Peter Zijlstra <peterz@infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arm@kernel.org" <arm@kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Chris Zankel <chris@zankel.net>, Max Filippov <jcmvbkbc@gmail.com>
Subject: Re: [PATCHv2 0/6] Make ARM's sched_clock generic + 64 bit friendly
Message-ID: <20130617180211.GJ10269@tarshish>
References: <1370155183-31421-1-git-send-email-sboyd@codeaurora.org>
 <51AD32A4.5070609@linaro.org>
 <20130604160907.GW27516@mudshark.cambridge.arm.com>
 <51AE2980.6010005@linaro.org>
 <20130616094501.GG10269@tarshish>
 <51BF37E4.8020006@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51BF37E4.8020006@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John,

On Mon, Jun 17, 2013 at 09:23:00AM -0700, John Stultz wrote:
> On 06/16/2013 02:45 AM, Baruch Siach wrote:
> >On Tue, Jun 04, 2013 at 10:53:04AM -0700, John Stultz wrote:
> >>On 06/04/2013 09:09 AM, Will Deacon wrote:
> >>>On Tue, Jun 04, 2013 at 01:19:48AM +0100, John Stultz wrote:
> >>>>On 06/01/2013 11:39 PM, Stephen Boyd wrote:
> >>>>>This is mostly a resend of a patch series I sent a little over a month
> >>>>>ago. I've reordered the patches so that John can pick up the first three
> >>>>>and get a generic sched_clock layer without having to take the 64 bit
> >>>>>patches. The last three patches add 64 bit support and move the architected
> >>>>>timers on ARM64 and ARM to use it.
> >>>>Yea, so from the initial look over it, I think I'm happy with queuing
> >>>>the first three patches, although I'd like to get some acks from arm
> >>>>folks on at least the first two, just so no one is surprised with it
> >>>>going through the -tip tree.
> >>>The first two patches are pretty simple so, FWIW, you can add my ack on those:
> >>>
> >>>   Acked-by: Will Deacon <will.deacon@arm.com>
> >>Thanks! Added to the commits.
> >What is the status of this series then? Is there a chance of seeing it in
> >3.11? I want to base some xtensa architecture work on this, so I'd like to
> >know whether there is a stable base to start from.
> I've got the first three in my internal tree, and was going to send
> it by Thomas for 3.11 this week.

Good, thanks. This means that the xtensa ccount sched_clock patch 
(http://lists.linux-xtensa.org/pipermail/linux-xtensa/Week-of-Mon-20130617/001077.html) 
that depends on the third patch in this series, can go in for 3.11, if the 
xtensa maintainer acks it (added to Cc). How should we handle the dependency 
then?

baruch

-- 
     http://baruch.siach.name/blog/                  ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
