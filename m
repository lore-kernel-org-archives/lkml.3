Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753811Ab3LZTR0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 14:17:26 -0500
Received: from mail.wdtv.com ([66.118.69.84]:59181 "EHLO mail.wdtv.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753672Ab3LZTRZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 14:17:25 -0500
From: Gene Heskett <gheskett@wdtv.com>
To: lkml <linux-kernel@vger.kernel.org>
Subject: Re: section miss-matches in older 3.8.3 kernel, and one question
Date: Thu, 26 Dec 2013 14:17:08 -0500
References: <201312261358.59464.gheskett@wdtv.com>
In-Reply-To: <201312261358.59464.gheskett@wdtv.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1256"
Content-Transfer-Encoding: 7bit
Message-Id: <201312261417.08678.gheskett@wdtv.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 December 2013, Gene Heskett wrote:
>Greetings;
>
>In my attempts to find a 64 bit or PAE enabled kernel to run on my older
>ASUS M2N-SLI Delux mobo, I saw a note go by during the build that there
>were 9 section-miss-matches.
>
>But when I applied the cli option recommended to the make lines in my
>makeit script, I only got these 2 squawks.
>
>WARNING: drivers/net/ethernet/amd/depca.o(.text+0xcce): Section mismatch
>in reference from the function depca_isa_probe() to the function
>.init.text:DepcaSignature()
>The function depca_isa_probe() references
>the function __init DepcaSignature().
>This is often because depca_isa_probe lacks a __init
>annotation or the annotation of DepcaSignature is wrong.
>
>WARNING: drivers/net/ethernet/amd/depca.o(.text+0xd22): Section mismatch
>in reference from the function depca_isa_probe() to the function
>.init.text:depca_hw_init()
>The function depca_isa_probe() references
>the function __init depca_hw_init().
>This is often because depca_isa_probe lacks a __init
>annotation or the annotation of depca_hw_init is wrong.
>
>I am not capable to fixing these, too many years & miles on the wet ram,
>but I thought that maybe someone might be interested.
>
>Also, these kernels seem to want to drop me to an initramfs$ prompt,
>where, since both kayboard and mouse are wireless usb, there is no
>connection, so I have to hit the reset button & try a known good kernel.
>
Never mind the following question, the 3.8.3 I was working on just booted, 
seems to be running nicely.

Thanks & Happy Holidays to all.

>Has the use of mkinitramfs been deprecated? and if so, replace by what?
>
>Thanks.
>
>Cheers, Gene


Cheers, Gene
-- 
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Genes Web page <http://geneslinuxbox.net:6309/gene>

System going down in 5 minutes.
A pen in the hand of this president is far more
dangerous than 200 million guns in the hands of
         law-abiding citizens.
