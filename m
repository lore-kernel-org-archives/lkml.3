Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754378Ab3ILIco (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 04:32:44 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:64422 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935Ab3ILIcm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 04:32:42 -0400
Date: Thu, 12 Sep 2013 12:32:17 +0400
From: Andrew Savchenko <bircoph@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org,
        suspend-devel@lists.sourceforge.net, viro@zeniv.linux.org.uk,
        linux-pm@vger.kernel.org
Subject: Re: [Suspend-devel] [BUG] 3.7-rc regression bisected: s2disk fails
 to resume image: Processes could not be frozen, cannot continue resuming
Message-Id: <20130912123217.e1764291616cf8e59f0f92b8@gmail.com>
In-Reply-To: <2662480.5erkm9ACQI@vostro.rjw.lan>
References: <20130812234415.7db639bb0d664e56b6ab2ab2@gmail.com>
	<20130827074843.ba1b6f62cc0a6dca8e47c06c@gmail.com>
	<20130905120811.GC15161@amd.pavel.ucw.cz>
	<2662480.5erkm9ACQI@vostro.rjw.lan>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__12_Sep_2013_12_32_17_+0400_vA=0O4DjQlwtfJbC"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__12_Sep_2013_12_32_17_+0400_vA=0O4DjQlwtfJbC
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

On Thu, 05 Sep 2013 14:23:25 +0200 Rafael J. Wysocki wrote:
> On Thursday, September 05, 2013 02:08:11 PM Pavel Machek wrote:
> > Hi!
> >=20
> > Rafael, Al: apparently we have a regression caused by
> > ba4df2808a86f8b103c4db0b8807649383e9bd13 .
>=20
> I noticed that, but I'm not sure how to deal with it.
>=20
> Also, s2disk still works on my test machines, so that seems to be
> specific to this particular configuration.

Is there any way to debug this issue further than just bisecting
commit? Perhaps suspend ioctl should be traced to see why it fails,
but I don't know what exactly inside the kernel should be debugged
and how.

Best regards,
Andrew Savchenko

--Signature=_Thu__12_Sep_2013_12_32_17_+0400_vA=0O4DjQlwtfJbC
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJSMXwlAAoJEFZZU7lTcnVstv8P/iZYXjqI1rMeeTk9kohTnDUu
4iXBe3kMOsv/2FAHVQ90AI/WgWYFSv2eDIRYywDt276JsLYIk1EpzO8OpN9nVyaT
Q8FfwXUXUJ4YCz9k+QzvAVN3BVIFIfCz/eqR4MXLBtGAhkL1NzwOIA/HwzK9saZo
KTuRKCM/IS5bx/uQvLvYEN45T02c+EAjuKxvPHKPA48Ea6xnGmQWuT0qXn7k1y93
Mf9N/go3YJ+jkk0mqjpveQpH6bd5CS2p+fDcD/n8w+4+Am9nw6ywuY6jhNzrVNV4
T2f5fwcmvU16dOqR7i+01JKa1xwcb9rRBMTH8L9kCfVhGpW09YZhDPs/Gy6oHXNp
Sy0GoQbtXtujxC3z4U0IM/AAVwN3cJQQVZH1EsdwIkMjbpAkk0tvTOjgjorFs3CP
bEbcOl8DU43PH+FujcRIcuvHFerfyqOi8x9ovcw+sJ4iQQBrs7AFb8dobWIQtbVe
NcGndaikJO2lCTZb/MCgXwlmBfAefDXSUjJssbpvpZ0tCtpcPfWEZwmrcMjJX0d8
/O/0gQ8f2trpufC+IdB+HVOjEXzkD44CUoQN0DkCyz+4MjBjPTlhzFpQ8OV/EIpJ
Trcit+AhE7lKkdbvhB/w4PfBo3A2zdNgWIKlk3/ERXfJZGQmvGemIY3A5A1uOGlk
5FViGZq4H9ZOon8TBH5j
=NP95
-----END PGP SIGNATURE-----

--Signature=_Thu__12_Sep_2013_12_32_17_+0400_vA=0O4DjQlwtfJbC--
