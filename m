Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751795Ab3JZKMN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Oct 2013 06:12:13 -0400
Received: from hygieia.santi-shop.eu ([78.46.175.2]:43442 "EHLO
	hygieia.santi-shop.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383Ab3JZKML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Oct 2013 06:12:11 -0400
X-Greylist: delayed 625 seconds by postgrey-1.27 at vger.kernel.org; Sat, 26 Oct 2013 06:12:11 EDT
Date: Sat, 26 Oct 2013 12:01:38 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: dbz <divide_by_zero@mail.ru>
Cc: linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org
Subject: Re: ddccontrol doesn't work on the new kernel
Message-ID: <20131026120138.150e70da@neptune.home>
In-Reply-To: <1382708930.658156307@f345.i.mail.ru>
References: <1382708930.658156307@f345.i.mail.ru>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.17; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CCing intel-gfx as it is related to intel GPU driver and might get missed
by intel developers on LKML.

Looking at the linked pastebins ddcontrol seems to make use of the same
i2c/DDC line but getting different results.

Surprising info I see in dmesg, that does apply to both kernels, is
that uvesafb attaches intel GPU *after* i915/KMS has done so.
Both i915 and uvesafb seem to be modular.

Bruno


On Fri, 25 October 2013 dbz <divide_by_zero@mail.ru> wrote:
> Hi, guys and girls!
> 
> I have a strange trouble with ddccontrol that I cannot identify and solve
> for about a month, so I hope you'll be able to help me.
> 
> So, I'm using LMDE system (http://linuxmint.com/start/debian/). Initially
> the kernel was 3.2.32, and ddccontrol worked perfectly with my Philips
> 232E2SB. I was able to change monitor brightness through ddccontrol
> commands and I was really happy :)
> 
> Then I upgraded my system to Update Pack 7, and the new kernel became of
> version 3.10.5. On new kernel ddccontrol doesn't work anymore, but it still
> works on the old one (so this isn't software issue).
> 
> I have checked kernel configs - for the old kernel and for the new one.
> Both configs are identical at i2c sections. I've tried to use old (3.2.32's
> one) config with the new kernel, but there was no success.
> 
> To be absolutely sure that the problem isn't in the this specific kernel
> version (3.10.5), I've downloaded the latest one (3.11.3) from kernel.org and
> tried to use old config on this new kernel, but the issue is still
> reproducing...
> 
> It would be great if you can give me right direction on this issue, 'cause
> I don't know what to do now... I really need new kernel and ability to use
> ddccontrol.
> 
> P.S. Additional info:
> ----------------------------
> The output of 'i2cdetect -l' on the old kernel (3.2.32):
> http://pastebin.com/SqDPcwS9
> The same on the new one (3.10.5): http://pastebin.com/YCTmX90m
> 
> The output of 'ddccontrol -p' on the old kernel (3.2.32):
> http://pastebin.com/QL0fAZVC
> The same on the new one (3.10.5): http://pastebin.com/vZ4bALmt
> 
> And dmesg outputs for both 3.2.32 and 3.10.5 kernels:
> - 3.2.32: http://pastebin.com/7ijujvkA
> - 3.10.5: http://pastebin.com/t1wdKrAd
> 
> I really need someone's help with ddccontrol. It would be great if you or
> someone else who do you know can help me :)
> 
> Thank you in advance!
