Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759698Ab3LBVUp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 16:20:45 -0500
Received: from mail.skyhub.de ([78.46.96.112]:37720 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756768Ab3LBVUD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 16:20:03 -0500
Date: Mon, 2 Dec 2013 22:19:58 +0100
From: Borislav Petkov <bp@alien8.de>
To: John Stultz <john.stultz@linaro.org>
Cc: Brecht Machiels <brecht@mos6581.org>, Thomas Gleixner <tglx@linutronix.de>,
        Jonathan Nieder <jrnieder@gmail.com>,
        Heinz Wiesinger <HMWiesinger@gmx.at>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [REGRESSION] 41c7f74 rtc: Disable the alarm in the hardware (v2)
Message-ID: <20131202211958.GE7380@pd.tnic>
References: <20131201220343.2285b12ee1c1e54252dc7dd9@mos6581.org>
 <529CF1D5.6010406@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <529CF1D5.6010406@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 02, 2013 at 12:47:17PM -0800, John Stultz wrote:
> Ok, sorry about this. I've been hoping we'd get some better insight
> into what's actually happening on these strange BIOSes where disabling
> the irq seems to cause it to scream (powering the system back on when
> its shutdown), in the hopes of having a proper workaround. But despite
> Borislav's efforts, he didn't seem to be able to root cause the issue.

Right, this bug is too nasty - you could generate good random numbers
just from how the hardware behaves. :) And I've been trying to make
sense of what happens but I failed, as you know. :(

I consider it a huge waste of time and efforts having to deal with such
b0rked hardware instead of throwing it out of the window into the poring
rain while it is still powered.

> Borislav, could you double check this patch still works on your
> hardware as well?

Well, we have the patch in SLES11:

http://kernel.opensuse.org/cgit/kernel/commit/?h=SLE11-SP3&id=835398eb94dca7d55acd1a2628372e602ae3252a

and it passed testing.

>From what I see below, your version is equivalent to the one above
with the logic reversed so it should work. I'll still try to get that
affected box and run your version on it but it'll take a while.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
