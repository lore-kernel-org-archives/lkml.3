Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752641Ab3GQHtL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 03:49:11 -0400
Received: from mail-ea0-f175.google.com ([209.85.215.175]:63953 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340Ab3GQHtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 03:49:09 -0400
Message-ID: <51E64C6B.3080306@monstr.eu>
Date: Wed, 17 Jul 2013 09:48:59 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>, Jens Axboe <axboe@kernel.dk>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: scatterlist: sg_set_buf() argument must be in linear mapping (sha1:
 ac4e97abce9b80c020e7113325f49e58b7b15e3f)
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2SFUCEAMFCMUSUWMNKSVB"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2SFUCEAMFCMUSUWMNKSVB
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Rusty and Jens,

I am getting problem with your patch which you have added to the kernel.
The problem is with my arm zynq remoteproc driver where
I use dma_declare_coherent_memory() to specify memory for remoteproc
which is ioremap to the vmalloc area.

Based on that buf addr is not inside ram even this coherent memory is in =
ram.
That's why virt_addr_valid(buf) is failing.

Thanks for you input,
Michal
--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



------enig2SFUCEAMFCMUSUWMNKSVB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlHmTGwACgkQykllyylKDCE7ZACfeMDPiVTaXHnq+0v+9qI1uyDm
PsIAn2o9hABBcv+TCeAXkN76ZbBVefSe
=MDUv
-----END PGP SIGNATURE-----

------enig2SFUCEAMFCMUSUWMNKSVB--
