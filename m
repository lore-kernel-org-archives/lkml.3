Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426Ab3CRPEB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 11:04:01 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:51906 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751986Ab3CRPD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 11:03:59 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jonas Jensen <jonas.jensen@gmail.com>
Subject: Re: [PATCH] ARM: mach-moxart: platform port for MOXA ART SoC
Date: Mon, 18 Mar 2013 15:03:49 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-8-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, Daniel Mack <zonque@gmail.com>,
        linux@arm.linux.org.uk, linux-mmc@vger.kernel.org, jirislaby@gmail.com,
        linux-kernel@vger.kernel.org
References: <CACmBeS1NLFUYHBOVL28aCCzRrgXYGPZF9t3qj6AdcgaMkrPGoQ@mail.gmail.com> <201303151125.53999.arnd@arndb.de> <CACmBeS3aXs9vhc5ZYPbz5bjsYsSa6EzM12H4uPv706x0zU_5iw@mail.gmail.com>
In-Reply-To: <CACmBeS3aXs9vhc5ZYPbz5bjsYsSa6EzM12H4uPv706x0zU_5iw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201303181503.49491.arnd@arndb.de>
X-Provags-ID: V02:K0:Mj0MxUEM9M1IC/u0B9tKnyZN3GfBPbucpIEKj0rOxvv
 /q8363YuD+SD06S2f03liKnapWfOKMu9b4bR8EFErkKAeb8P2W
 oXQgDgr2n1Kb2h0sKX/7ts9K07kZdmZARlX54s0FmVW7chbRf+
 hz6ztXYzF6FOA1Z28NzoZ57rVoAcRk5tLfapX5h+VoW2HyZKGW
 XfGOXZi7q+h1bS8oHpJKsWtguYjDLFh54NSvkJS5xEwMvtcqo9
 Tva6vRcnh0GvjBEPn2DEnk0pwbv2EIp2hfZmqMNmRQrUCySHf3
 gZI8OV69JAONzEpZmkKIRbWg9/5/hz+CW7/Njl4ASMv7D3zUPI
 Y24y5h1hejRVIeD1vVBg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 17 March 2013, Jonas Jensen wrote:
> Thank you for the feedback.
> 
> Some of the changes are sure to be a challenge for me, but I want to
> move this forward, and having a list helps.
> 
> 3.2.40 is as far as it'll go right now, nothing prints to UART
> starting with 3.3.8 (last tested, it's somewhere around there).
> 
> I have been advised to enable early_printk (by landley on freenode IRC #edev).

Yes, that is a good idea. I would also suggest that you don't try to port
all the code at once a few kernel versions at a time, but that you instead
move straight to the latest kernel, and basically start a new port one driver
at a time. Take one of the newer ports (highbank, virt, bcm, ...) as examples.

Since most of the code is now in drivers/ directories rather than arch/arm,
you can actually start getting stuff upstream before you have completed all
of it. If you have questions, I recommend asking on the #armlinux channel
on freenode, or here on the mailing list.

	Arnd
