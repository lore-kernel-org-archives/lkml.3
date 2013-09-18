Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752505Ab3IRP4S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 11:56:18 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:55817 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652Ab3IRP4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 11:56:17 -0400
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Javier Martinez Canillas <martinez.javier@gmail.com>
Subject: Re: [PATCH 1/4] usb: musb: Call atomic_notifier_call_chain when status is changed
Date: Wed, 18 Sep 2013 17:56:12 +0200
User-Agent: KMail/1.13.7 (Linux/3.11.0-1+synaptics-generic; KDE/4.11.1; x86_64; ; )
Cc: Pavel Machek <pavel@ucw.cz>, Felipe Balbi <balbi@ti.com>,
        Tony Lindgren <tony@atomide.com>, Anton Vorontsov <anton@enomsg.org>,
        Russell King <linux@arm.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        freemangordon@abv.bg, Aaro Koskinen <aaro.koskinen@iki.fi>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org
References: <1378630239-10006-1-git-send-email-pali.rohar@gmail.com> <20130918133025.GB2953@amd.pavel.ucw.cz> <CAAwP0s0nGthkm9Bp1ug23Rtz6-sbR60FFTSfd-Cj9wKMU0RBEA@mail.gmail.com>
In-Reply-To: <CAAwP0s0nGthkm9Bp1ug23Rtz6-sbR60FFTSfd-Cj9wKMU0RBEA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart8313442.1feUBW3l9A";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201309181756.12782@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart8313442.1feUBW3l9A
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wednesday 18 September 2013 15:57:13 Javier Martinez Canillas=20
wrote:
> to split the patch in two since the patch was solving
> two separate issues

My patch does not solving *two* issues. It is *one* regression=20
and both parts of patch are needed for fixing it. Read commit=20
message again. It does not make sense to split patch fixing kernel=20
regression into more one line patches - or please clarify why.

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart8313442.1feUBW3l9A
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlI5zRwACgkQi/DJPQPkQ1J/2QCgtFQe8mTu4aIHC5OhRIbOy+ai
j+kAoLhlbffqZMhNXyb2DrhOLlJaNZof
=G+Io
-----END PGP SIGNATURE-----

--nextPart8313442.1feUBW3l9A--
