Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932145AbaKKLxR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 06:53:17 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:57999 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752252AbaKKLxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:53:13 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] rtc: Disable EFI rtc for x86
Date: Tue, 11 Nov 2014 12:53:09 +0100
User-Agent: KMail/1.13.7 (Linux/3.17.0-031700rc6-generic; KDE/4.14.1; x86_64; ; )
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Austin S Hemmelgarn <ahferroin7@gmail.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Matt Fleming <matt.fleming@intel.com>, Borislav Petkov <bp@alien8.de>,
        Mark Salter <msalter@redhat.com>,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dave Young <dyoung@redhat.com>
References: <1412339576-17972-1-git-send-email-matt@console-pimps.org> <546126FF.3070600@zytor.com> <20141111113831.1119720e@alan.etchedpixels.co.uk>
In-Reply-To: <20141111113831.1119720e@alan.etchedpixels.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1711919.8syZGNo1x9";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201411111253.10519@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1711919.8syZGNo1x9
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tuesday 11 November 2014 12:38:31 One Thousand Gnomes wrote:
> > > look further into the options I have set in my kernel
> > > build, I may have changed something else without
> > > remembering between booting with and without the CSM
> > > enabled.
> >=20
> > It could also be that the non-CSM BIOS somehow remaps the
> > CMOS registers.
>=20
> I don't believe there is anything which prevents the CSM from
> faking a CMOS clock using SMM from whatever is actually in
> the hardware.
>=20
> Alan

Also in case when we do not know what SMM code is doing...

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart1711919.8syZGNo1x9
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlRh+KYACgkQi/DJPQPkQ1KFxwCfTFedJgATyEqQE98oxKDEKLwu
Ps4AoLzksYZkbKuw8vXz7N0FSltpaY50
=Fjtv
-----END PGP SIGNATURE-----

--nextPart1711919.8syZGNo1x9--
