Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752229AbaATW1i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 17:27:38 -0500
Received: from mail-ee0-f51.google.com ([74.125.83.51]:59677 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452AbaATW1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 17:27:33 -0500
Message-ID: <52DDA2CD.9040001@dragonslave.de>
Date: Mon, 20 Jan 2014 23:27:25 +0100
From: Daniel Exner <dex@dragonslave.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Poor network performance x86_64.. also with 3.13
References: <52DAD66F.7080306@dragonslave.de> <20140118195026.GA15543@pd.tnic> <52DB0439.2060905@dragonslave.de>
In-Reply-To: <52DB0439.2060905@dragonslave.de>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Hi,

Am 18.01.2014 23:46, schrieb Daniel Exner:
> Hi again,
> 
> Am 18.01.2014 20:50, schrieb Borislav Petkov:
>> + netdev.
> Thx
> 
> Am 18.01.2014 20:49, schrieb Holger Hoffstätte:> [This mail was
> also posted to gmane.linux.kernel.]
> 
>> On Sat, 18 Jan 2014 20:30:55 +0100, Daniel Exner wrote:
> 
>>> I recently upgraded the Kernel from version 3.10 to latest 
>>> stable 3.12.8, did the usual "make oldconfig" (resulting
>>> config attached).
>>> 
>>> But now I noticed some _really_ low network performance.
> 
>> Try: sysctl net.ipv4.tcp_limit_output_bytes=262144
> 
> Tried that. Even 10 times the value. Same effect.


I just did the same procedure with Kernel Version 3.13: same poor rates.

I think I will try to see of 3.12.6 was still ok and bisect from there.

Greetings
Daniel
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCgAGBQJS3aLFAAoJEPI6v6bI/Qkf9+4QAJkfljUsRQn6DA6gWy3XYsn4
ZB3F2Mu8kLsCMVjpASsi7+km2qTiFv4qGOgezHCJmqMcdCFszBweGQrnYBLA5PCD
XSZ7G4S0U71aHWtY6iQd1q4ywnA21pfnGRqIpc5+OuIiIOm+YY+RXpJAHC5y1OVo
MxsPL1ZVp/enJoZuvblw6i+JT+soAbSypPWcNQ78qb+CYzLVMLZHcqQvMwpAsRvQ
LNKx8nyj8p32CdZo1GoT3f/nWvBeh/V/ViLrtt64u/oXMJyk5INVRFpSNUUviP8c
42y+r2K31+nY11K2dHsdJYbv5lZ8p8g0SNoLG1SrjgDspaptnT8jptxxn7GcQqdL
PZ3waUB7qYU15IxCA2iXwNPqjtsv8V5l55H/cunKQgxNbb318ui/a3cW7+R++CeL
onv9HFNUkHJiP/MvZJ1/FXE0AsjX70un9NuQ0+xFjCRwJ/YLZzCHkWMERcev500O
vS1yFTGiVY1HndoA4VFYzEkjOyHgDHHQA+0JkfBspVlhL7ow9hccmULZtEn9LzwU
9rooQHyXwdKr6KIbsjHECyjIsBhW4Jfj6195bZ9ddBDBXSqYyGqjiuy7l7TjlZVa
YmPNTlkEfMeXkO2h3km8TD2f+MPntYXkYjZVVUcK8NucgnIdLuWDk/GLrt73VTd8
Cww6B/u4YnGJSF5v/nit
=xCa3
-----END PGP SIGNATURE-----
