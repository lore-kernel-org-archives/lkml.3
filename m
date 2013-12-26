Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753748Ab3LZTFo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 14:05:44 -0500
Received: from mail.wdtv.com ([66.118.69.84]:57821 "EHLO mail.wdtv.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753611Ab3LZTFm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 14:05:42 -0500
From: Gene Heskett <gheskett@wdtv.com>
To: lkml <linux-kernel@vger.kernel.org>
Subject: section miss-matches in older 3.8.3 kernel, and one question
Date: Thu, 26 Dec 2013 13:58:59 -0500
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201312261358.59464.gheskett@wdtv.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings;

In my attempts to find a 64 bit or PAE enabled kernel to run on my older 
ASUS M2N-SLI Delux mobo, I saw a note go by during the build that there 
were 9 section-miss-matches.

But when I applied the cli option recommended to the make lines in my 
makeit script, I only got these 2 squawks.

WARNING: drivers/net/ethernet/amd/depca.o(.text+0xcce): Section mismatch in 
reference from the function depca_isa_probe() to the function 
.init.text:DepcaSignature()
The function depca_isa_probe() references
the function __init DepcaSignature().
This is often because depca_isa_probe lacks a __init 
annotation or the annotation of DepcaSignature is wrong.

WARNING: drivers/net/ethernet/amd/depca.o(.text+0xd22): Section mismatch in 
reference from the function depca_isa_probe() to the function 
.init.text:depca_hw_init()
The function depca_isa_probe() references
the function __init depca_hw_init().
This is often because depca_isa_probe lacks a __init 
annotation or the annotation of depca_hw_init is wrong.

I am not capable to fixing these, too many years & miles on the wet ram, 
but I thought that maybe someone might be interested.

Also, these kernels seem to want to drop me to an initramfs$ prompt, where, 
since both kayboard and mouse are wireless usb, there is no connection, so 
I have to hit the reset button & try a known good kernel.

Has the use of mkinitramfs been deprecated? and if so, replace by what?

Thanks.

Cheers, Gene
-- 
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Genes Web page <http://geneslinuxbox.net:6309/gene>

Vini, vidi, Linux!
A pen in the hand of this president is far more
dangerous than 200 million guns in the hands of
         law-abiding citizens.
