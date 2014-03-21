Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755226AbaCUR1w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 13:27:52 -0400
Received: from mail.skyhub.de ([78.46.96.112]:60212 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752933AbaCUR1u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 13:27:50 -0400
Date: Fri, 21 Mar 2014 18:27:42 +0100
From: Borislav Petkov <bp@alien8.de>
To: Matthias Graf <matthias.graf@st.ovgu.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: Fatal Machine Check >= 3.13.5-101.fc19.x86_64
Message-ID: <20140321172742.GA2846@pd.tnic>
References: <532C727F.1080803@st.ovgu.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <532C727F.1080803@st.ovgu.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 21, 2014 at 06:10:23PM +0100, Matthias Graf wrote:
> Please CC me on replies.
> 
> [1.] Kernel panic: Fatal Machine Check after booting >=
> 3.13.5-101.fc19.x86_64; 3.12.11-201.fc19.x86_64 works fine!
> [2.] Screen freezes a few seconds after Gnome appears. The error message
> (see attachement) is seldom still printed to the screen. Booting
> 3.12.11-201 with otherwise the same setup, I do not see the panic.
> Booting on different hardware (my laptop) does not produce the panic. I
> also notice low frames per seconds after gnome started up, right before
> the panic occures. I therefore suppose this is graphics hardware related.
> [3.] Fatal Machine Check Exception, RIP Inexact, apic_timer_interrupt,
> Kernel panic
> [4.] 3.13.6-100.fc19.x86_64 && 3.13.5-103.fc19.x86 && 3.13.5-101.fc19.x86_64
> [5.] OCRed: (see Attachement for photo)
> 
> Started Accounts Service.
> [ 34.348483] mce: [Hardware Error]: CPU 3: Machine Check Exception: 5 Bank 8: bZ88884888888888
> [ 44.468168] mce: [Hardware Error]: HIP ?IHEXﬁCT? 18:<ffffffff816881f8> {apicgtimer_interrupt+8x8/8x88}
> I 44.468168] mce: [Hardware Error]: TSC 36S??8ad8c
> f 44.468168] mce: [Hardware Error]: PROCESSOR 8:6fb TIM 138471666? SOCKET 8 HPIC 2 microcode ba
> I 44.468168] mce: [Hardware Error]: Run the above through 'mcelog ~~ascii’

This looks like you had some text recognition done on the jpeg. :-)

Please correct the error message to be exactly as in the jpeg and run it
through mcelog --ascii to see what that bank 8 is trying to tell us.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
