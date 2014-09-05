Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752208AbaIEVJQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 17:09:16 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:42037 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940AbaIEVJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 17:09:15 -0400
Message-ID: <540A266F.80503@gmail.com>
Date: Sat, 06 Sep 2014 00:09:03 +0300
From: =?UTF-8?B?VmxhZGltaXIgJ8+GLWNvZGVyL3BoY29kZXInIFNlcmJpbmVua28=?= 
	<phcoder@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>, Gerd Hoffmann <kraxel@redhat.com>,
        linux-kernel@vger.kernel.org
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "maintainer:X86 ARCHITECTURE..." <x86@kernel.org>,
        coreboot@coreboot.org
Subject: Re: [coreboot] [PATCH] x86: add coreboot framebuffer support
References: <1409826307-23075-1-git-send-email-kraxel@redhat.com> <540A17A6.1000802@zytor.com>
In-Reply-To: <540A17A6.1000802@zytor.com>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="IW2qqeO5pMga9m5T1EDCDxV93dMaq8nFg"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--IW2qqeO5pMga9m5T1EDCDxV93dMaq8nFg
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable


> I'm not a fan of Coreboot having invented its own nonstandard hacks, bu=
t
> I guess it is pretty much unavoidable.
It's completely avoidable. The stub can copy this information to
standard framebuffer info structure. The only missing thing is to apply
patch by cjwatson or mjg59 (I'm not sure now who wrote it) for having an
ID for linear framebuffer which implies no specific hardware (it can be
any) or firmware (coreboot doesn't provide nay additional info or callbac=
k).

Please don't apply this patch it will break SeaBIOS booting with VGABIOS.=



--IW2qqeO5pMga9m5T1EDCDxV93dMaq8nFg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iF4EAREKAAYFAlQKJnYACgkQmBXlbbo5nOuxxgD/TcHMkyETlQ1PL2QGwGZBTE5o
7+n9Xh8DLtC+SNx+wE0BAJ+L8gb5vtA0FCyabUkA/D7IPxA2GO8LKpKhZEVH6ddE
=8+Z1
-----END PGP SIGNATURE-----

--IW2qqeO5pMga9m5T1EDCDxV93dMaq8nFg--
