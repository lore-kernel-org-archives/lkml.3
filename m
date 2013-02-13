Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759048Ab3BMISw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 03:18:52 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:56036 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758790Ab3BMISu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 03:18:50 -0500
Message-ID: <511B4C60.50404@ti.com>
Date: Wed, 13 Feb 2013 10:18:40 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Ruslan Bilovol <ruslan.bilovol@ti.com>
CC: <andi@etezian.org>, <FlorianSchandinat@gmx.de>,
        <linux-fbdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
Subject: Re: [PATCH v2 0/1] OMAP4: DSS: Add panel for Blaze Tablet boards
References: <1360338220-12753-1-git-send-email-ruslan.bilovol@ti.com>
In-Reply-To: <1360338220-12753-1-git-send-email-ruslan.bilovol@ti.com>
X-Enigmail-Version: 1.4.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enig7C42D7DB9231EA301660D5C9"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------enig7C42D7DB9231EA301660D5C9
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,

On 2013-02-08 17:43, Ruslan Bilovol wrote:
> Hi,
>=20
> This patch adds support for TC358765 DSI-to-LVDS transmitter
> from Toshiba, that is used in OMAP4 Blaze Tablet development
> platform. It was originally developed a long time ago and
> was used internally survived few kernel migrations.
> Different people worked in this driver during last two
> years changing its sources to what each new version of
> kernel expects.
>=20
> Current version is ported from internal kernel v3.4 to 3.8.0-rc6
> Tested basic functioning under busybox.

Thanks for updating the driver to a recent kernel.

I didn't review the patch line by line, but with a brief look it looks
fine. However, I'm not quite sure what to do with this patch.

The problem is that the driver is a combined driver for the TC358765
chip and the panel on Blaze Tablet, and we are very much trying to fix
that design issue so that the drivers for the chip and panel could be
separate, as they should.

So I fear that if I now accept the patch, it'll increase my burden of
managing the display drivers during this design rework. Furthermore, to
my knowledge the Blaze Tablet is quite a rare board, and it's not even
supported in the mainline kernel, so this driver wouldn't be usable by
itself.

So if I'm right about the blaze tablet status, I'm inclined to say that
I think this should be still kept out of tree.

 Tomi



--------------enig7C42D7DB9231EA301660D5C9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with undefined - http://www.enigmail.net/

iQIcBAEBAgAGBQJRG0xkAAoJEPo9qoy8lh71r6IP/0qk60F4MHPxuzjy3UE2DbZm
zMjWafevHubQfbfV+GmHbPlTJ5Q+igO4q5T2TTCbpWLVVBh2ettPhO7hRi24cwuF
fRt89KvprzUx4QY6Up2SJtMr8RqDjC/f9J+rytfAJZ7eNM8lPBGt75oU0z3MWvwm
srMK/IFCfuB/n7cThZL5NxiVJKOHGzy4lVUgPYPg2+OssSnvvfJ1/xf78XJSkxoI
R2vjlFe91LjuKvFFqWr4Gy0CFSdmn1wHGzG+ZDefmdh6mhoEQYALqXQQn6qkpgQC
MzuAHHZlSWBCYy+pCgYRVs9rvmaM1JJLut/b0uWrE0qrF7Fv1CbgkjI/Kk3Tv13d
FiODNVnORopRx1eXHxgG1L5uppFf9cnarb72ma2t4Ix/Tws+x6AMrgM75cRR6pjo
5Ni1nzhiCPkIGxkko1WAcGIm2F/Wf8TXI7KwiQbNIPN+eYGZMfF/LvdTmpRnrZ7o
zxfLlPbyw8HuLN2/HkVMhZPCgBbBVUUFIkVH5jJU+pL2EzvOj4hykxcYxIYJjJGw
OJVqFvU0AanpuvoCtxsWY2WosRrj6x7Hc2G4g5HXFeHvSHThCvsLYr3rkGxh1eHd
YfdXSmbCQNVD7fueT1jrEqCF+agvJjmRaNYpJCMo8AhQronkpgkocKaB80kqFl3R
jdG0kwUuz2lvo1PntM2s
=dLJt
-----END PGP SIGNATURE-----

--------------enig7C42D7DB9231EA301660D5C9--
