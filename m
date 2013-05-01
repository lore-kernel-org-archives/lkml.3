Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756194Ab3EASwx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 14:52:53 -0400
Received: from static.52.99.9.5.clients.your-server.de ([5.9.99.52]:50124 "EHLO
	mail1.project-insanity.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755412Ab3EASwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 14:52:46 -0400
Date: Wed, 1 May 2013 18:51:05 +0000
From: Jonas Heinrich <onny@project-insanity.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: len.brown@intel.com, pavel@ucw.cz, tglx@linutronix.de, mingo@redhat.com,
        x86@kernel.org, rjw@sisk.pl, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: [Bisected] 3.7-rc1 can't resume (still present in 3.9)
Message-ID: <20130501185104.GC488@onny>
References: <20130218155439.GA902@onny>
 <cfd96a3d-5834-4687-b9de-9f044f43b588@email.android.com>
 <20130223131856.GA682@onny>
 <51293A8B.5060107@zytor.com>
 <20130320143257.GA473@onny>
 <20130501170118.GB488@onny>
 <518151DD.106@zytor.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="O8XZ+2Hy8Kj8wLPZ"
Content-Disposition: inline
In-Reply-To: <518151DD.106@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--O8XZ+2Hy8Kj8wLPZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Well, you could give me instructions on how to debug this (I'll do
everything ;)) or I could ship you the Thinkpad T43. I guess this would
worth the effort since this bug is somehow critical.

Best regards,
Jonas

On 05-01 10:33, H. Peter Anvin wrote:
> On 05/01/2013 10:01 AM, Jonas Heinrich wrote:
> > Hello, I tried the newest kernel, 3.9 today but the bug is still
> > present. Applying the attached patch solves the bug for me.
> >=20
> > Best regards, Jonas Heinrich
>=20
> Okay... WTF is going on here?  Does pmode_behavior just not get set up
> correctly?  Since it seems you can get it to wake up with your patch,
> perhaps we can get read out the value of pmode_behavior and print it...
>=20
> 	-hpa
>=20
>=20

--O8XZ+2Hy8Kj8wLPZ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQEcBAEBAgAGBQJRgWQYAAoJEPFqEBdQ3ykkJFQH/RalwGaQmRKRhjyvX3K8dixX
6arSqkp8VgHaoxzACMNLMMT0ouE1konQj5HqYkF/KAT3AsvCe0FPR/eiUfIJrjZx
oRAzp+jVkfZ8GSWY9x02NRUmj+hg46gu4OeFMBrV8sa10BYmnMDlw0LgIO44KgFC
9jfTbYrQLnRv+tRD8r3szUcob8ysWwR1gPGFVq38/B4RehOF0Iiyd4XV5+xJjqD5
mdaRjJF1eYlnCCHBwrBVGQ9of9STyKIHComk6Ucb6adUIYi3Optgl7e9GMovxB4A
3Y1YYzOayM36a+1qt8mds8ulQWKTW/15RZlcZY8zO1xcyJZkrM5kK13cwD5Eakk=
=hfkE
-----END PGP SIGNATURE-----

--O8XZ+2Hy8Kj8wLPZ--
