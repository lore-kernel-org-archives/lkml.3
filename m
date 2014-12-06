Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752557AbaLFNAS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 08:00:18 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:37339 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752453AbaLFNAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 08:00:15 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Ming Lei <ming.lei@canonical.com>
Subject: Re: wl1251: NVS firmware data
Date: Sat, 6 Dec 2014 14:00:11 +0100
User-Agent: KMail/1.13.7 (Linux/3.18.0-031800rc5-generic; KDE/4.14.1; x86_64; ; )
Cc: "John W. Linville" <linville@tuxdriver.com>,
        Grazvydas Ignotas <notasas@gmail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Pavel Machek <pavel@ucw.cz>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>, Kalle Valo <kvalo@adurom.com>,
        Sebastian Reichel <sre@ring0.de>,
        David Gnedt <david.gnedt@davizone.at>
References: <201411271506.20457@pali> <201411271543.23527@pali> <CACVXFVMCJxQRUo94C8peT7G-VFkVeNYCWGKPYE5jq=twCULrpA@mail.gmail.com>
In-Reply-To: <CACVXFVMCJxQRUo94C8peT7G-VFkVeNYCWGKPYE5jq=twCULrpA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3920280.KLWdcTxFn6";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201412061400.11406@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3920280.KLWdcTxFn6
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thursday 27 November 2014 16:13:51 Ming Lei wrote:
> > Which userspace helper programs for (automatic) firmware
> > loading are used? Can be udev configured to use own program
> > for loading
>=20
> At default, udev had its builtin firmware helper, but some new
> udev stops to handle firmware request.
>=20
> If the udev you are using still supports to handle firmware
> request, you can write your load helper and add your rule for
> handling the special case. Otherwise, you need to write code
> to monitor the netlink uevents from the kernel and handle
> your firmware loading request.
>=20
> Thanks,
> Ming Lei

=46or Nokia N900 (and Maemo system) we are using older udev version=20
(0.125), so here should be support for firmware helper.

And if some new udev version will not work, we can just revert=20
back to older working... No need to use super-uber-fantastic=20
systemd-udevd software which removing old useful code.

So looks like adding new rule file to udev for handling firmware=20
requests from kernel could work...

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart3920280.KLWdcTxFn6
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlSC/dsACgkQi/DJPQPkQ1LW0wCdHNXDxWf9cplGRZ/UoMOq/0AA
5g0AnAt0Mc6UgJCnsqCOORi2jzB2XkjA
=PR6b
-----END PGP SIGNATURE-----

--nextPart3920280.KLWdcTxFn6--
