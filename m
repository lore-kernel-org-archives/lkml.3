Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756818Ab3J1Omz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 10:42:55 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:47046 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756470Ab3J1Omm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 10:42:42 -0400
Date: Tue, 29 Oct 2013 01:42:34 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nicolin Chen <b42378@freescale.com>
Subject: linux-next: build failure after merge of the final tree (sound tree
 related)
Message-Id: <20131029014234.fa29fdc685dbd73934cf1768@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.21; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__29_Oct_2013_01_42_34_+1100_GP1HOqiORDW6=VfB"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__29_Oct_2013_01_42_34_+1100_GP1HOqiORDW6=VfB
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (i386 defconfig)
failed like this:

sound/built-in.o: In function `snd_free_dev_iram':
(.text+0x17028): undefined reference to `gen_pool_free'

Presumably caused by commit 055032142c42 ("ALSA: Add SoC on-chip internal
ram support for DMA buffer allocation") from the sound tree.

I have left this broken for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__29_Oct_2013_01_42_34_+1100_GP1HOqiORDW6=VfB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBCAAGBQJSbnffAAoJEMDTa8Ir7ZwVDrMP/3cBbSqHvqLv/Ve+DDeGQ3RX
fU0RuJNQA+gj2qzyjCTvzFFBiMjW20ZrD584xoLIh0ZvEwhj/2P9grhwwvyLTpge
kOd0X+XiV95ru/fEuxf6MwVI4N1PpdzXedE6Z8k4QUqlg9ZklDTMEVhyaZE1DaFz
qvGC/NUBUCjiCC6l1/+alaGblB+FR3zunyqGOtQwF2oy2QJsbTSFODxXSd6/dzOR
pxz4ICKu7CJMQDSj17a1IKxRzKmuYciBQlizjCVzwDuMMOOTN0wVXhzfi1sH2jKP
zyKqKexa3DySoz5Ta0VkHOcVZW1wIBg90OYys+TIrH/h/eU+7GnXZ+29yTF60DHz
PZaxoNPp0MSCewSahHbeH+8BV8+po2d/YBVA7DFOF/Gshdrk/d8QiqvtU72JnjlO
vpV7kYRzijUmf5QdxM9IizgC/3jLCY4Vo42p/pwvaIp7Td8evXwibWbN4KIlfgY3
PxsngJe/ssLfee4rmU1v7fCkgUh82vtkqIE+P4eWfiCcb+4bmbUBKkXsOVA58MFw
qh/pUm9erhQOaO2E9p7uR4BQ7+hIa4EGOMYPc13Lg5k2yFWgjGEZKh55MTACmWgu
DRD++JsJNOZjiqNwi9xn05PtL5wZbQPnQdHARCnlXRb9rMXVkmO46LltiF4aXWIM
aGyj1Q6P+IrwrLdaVQF0
=kltc
-----END PGP SIGNATURE-----

--Signature=_Tue__29_Oct_2013_01_42_34_+1100_GP1HOqiORDW6=VfB--
