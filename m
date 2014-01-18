Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751651AbaARWql (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jan 2014 17:46:41 -0500
Received: from mail-ee0-f50.google.com ([74.125.83.50]:43071 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533AbaARWqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jan 2014 17:46:24 -0500
Message-ID: <52DB0439.2060905@dragonslave.de>
Date: Sat, 18 Jan 2014 23:46:17 +0100
From: Daniel Exner <dex@dragonslave.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: 3.12.8 poor network performance x86_64
References: <52DAD66F.7080306@dragonslave.de> <20140118195026.GA15543@pd.tnic>
In-Reply-To: <20140118195026.GA15543@pd.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Hi again,

Am 18.01.2014 20:50, schrieb Borislav Petkov:
> + netdev.
Thx

Am 18.01.2014 20:49, schrieb Holger Hoffstätte:> [This mail was also
posted to gmane.linux.kernel.]
> 
> On Sat, 18 Jan 2014 20:30:55 +0100, Daniel Exner wrote:
> 
>> I recently upgraded the Kernel from version 3.10 to latest
>> stable 3.12.8, did the usual "make oldconfig" (resulting config
>> attached).
>> 
>> But now I noticed some _really_ low network performance.
> 
> Try: sysctl net.ipv4.tcp_limit_output_bytes=262144

Tried that. Even 10 times the value. Same effect.

Is there something like that on a lower level of the network stack I
might try to change?

Could that be something in the cgroups layer?

Should I send a dmesg or anything else?

Greetings
Daniel
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCgAGBQJS2wQtAAoJEPI6v6bI/QkfKakP/jsv7VG5bUuSbvXjLQklb8mY
kGZvXRktpGMxHbUJe8NCLStbWcGLRoD+ilXh38e0U+icgU/f6uAa6a93cSaF+zi8
imjkyutQqAlevV3Ab3SAaSho6SsWgfTkWZ7kkFooIXU6UwIlqq41923OTpR2bXL4
qvYiYEOOO9Uzg/o0PXeV2VYcgxfnvTqRrpou3yQZK5YhLAZIHd8i9r1yqc+Un4dG
7+Ju/45YpqynX2CJVMx5kP62f9uQbdA9sEKoEkYInVtja0UGUwFXzHgy8RZLHDiM
Qhy/yZTzkjR4vai4N+dx2UizGBwgBtng5IzUiXX2HGd8TOMJRBcoPaa0ZBA4CsA+
RjypqL9dOGpw1bxZ/87h9qpvjmZd3mPhb768VKXgzgdEVlp56u5rT1OQEBUju8aS
Qprgtf6k1EkjJPWo3DVJrGr/Wk+k8cLASW5qm3wGS7V0k1H0EN+pw7UGvNY99kcf
IllTKa6bTkKe15x1BaZjvAwFHR1Fdcdn3A+2WQwy+hha1CsjogHnbhzUjmxHDq+c
8i92oZ1nw2788/ULPKc5hK2o8C4Zsp0JVGHd4Cy4Dy6tvCLSQveDneM/2U3JvCL2
ViOdxh6LGGWFvDpe1w9x+e3QzvXYTFNEXawn/5OIEzbM1XP+VF8zIyHsLG4nNI88
+ICSvsTt86Zg8Zhm96YH
=gsnO
-----END PGP SIGNATURE-----
