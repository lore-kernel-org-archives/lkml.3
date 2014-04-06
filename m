Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754238AbaDFJ4O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 05:56:14 -0400
Received: from ring0.de ([5.45.105.125]:51080 "EHLO ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754173AbaDFJ4L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 05:56:11 -0400
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from author's
	*       domain
	*  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
	*      valid
	* -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
	* -0.0 NO_RECEIVED Informational: message has no Received headers
Date: Sun, 6 Apr 2014 11:55:58 +0200
From: Sebastian Reichel <sre@ring0.de>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Greg KH <greg@kroah.com>, Pavel Machek <pavel@ucw.cz>, dtor@mail.ru,
        linux-input <linux-input@vger.kernel.org>,
        Jiri Kosina <jkosina@suse.cz>,
        Samuel Thibault <samuel.thibault@ens-lyon.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, jslaby@suse.cz,
        Richard Purdie <rpurdie@rpsys.net>,
        LKML <linux-kernel@vger.kernel.org>, Evan Broder <evan@ebroder.net>,
        Arnaud Patard <arnaud.patard@rtp-net.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 8 months to review a patch (was Re: [PATCH] Route kbd LEDs
 through the generic LEDs layer)
Message-ID: <20140406095556.GA30949@earth.universe>
References: <20111114040613.GA4992@type.famille.thibault.fr>
 <20121221003449.GA6999@type.youpi.perso.aquilenet.fr>
 <20130713093552.GU8252@type>
 <20130715091230.GA8786@amd.pavel.ucw.cz>
 <CAHYPw2H94ej=FdqHAxXpyZt+34TwK1Qj7LWP_bMro-v3JREisg@mail.gmail.com>
 <20140316101946.GJ6436@type.youpi.perso.aquilenet.fr>
 <CAHYPw2EAgjdcNATy0d6DhbT9qHAHJLda7gsLrnSJ7F4Cj=a-JQ@mail.gmail.com>
 <20140328070136.GA15953@amd.pavel.ucw.cz>
 <20140328071743.GA17588@kroah.com>
 <CAHYPw2FAVtxxt_6=LArC=T_Ca=+tTsE37U29mrY-=OViHXf_2g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="LZvS9be/3tNcYl/X"
Content-Disposition: inline
In-Reply-To: <CAHYPw2FAVtxxt_6=LArC=T_Ca=+tTsE37U29mrY-=OViHXf_2g@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LZvS9be/3tNcYl/X
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Pali,

On Sun, Apr 06, 2014 at 11:43:13AM +0200, Pali Roh=E1r wrote:
> Greg, problem is that Dmitry does not respond and has not reviewed
> this patch for more that 8 months. From my point of view this looks
> like Dmitry does not have time for review anymore...
>=20
> What to do if maintainer is busy for a long time?
> Really could not you look at this patch?
>=20
> https://lkml.org/lkml/2014/3/31/141

I don't think that he doesn't have time for review anymore, since
he is active in his git tree [0] and has sent a pull request to
torvalds recently [1].

Maybe this thread is blocked by gmail? Or he didn't notice, that
this patchset involves input.git, since the subject is mainly about
LEDs? Have you tried contacting him directly, possibly without
referencing the thread?

[0] https://git.kernel.org/cgit/linux/kernel/git/dtor/input.git/
[1] https://lkml.org/lkml/2014/4/3/154

-- Sebastian

--LZvS9be/3tNcYl/X
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJTQSSsAAoJENju1/PIO/qavUAP/RzFjd9muQJYVDlZPtn9els9
CkUob1rsyh1AQFiXSsMdHn/8u3OPMpSjXOmhQPaAj7IO0/AmyI54A3qKN/TpA+0J
cSo9CKYgE6rPxzv4lO4SNFJk7LG34jpHoiN0CfM5mmXw7dvnVdRCkYs9+lFOoNSb
Q1opf//RL5SlQ8AF5dMFEq7SB2hpb3X3+bgWrmozevsRvMeBBRMIl32VZ42BDiG3
amBaTiMbLh1YmyJVFkIWAFm1gRNdCwcdF0Huz1JfqT0HRRNYylN50+gZIhUn0yrw
gTxtE1VCZNJxBHRZ8XJYcPZ5kT8Uv2SflpwtsYk3ZYH3RUKRWLC6DLmPcC6dWwok
tOaBUdLfuEHk4wz+L/LH5YNOSUFJ0jJRIN0yEJP/VlGfglfKYH4b+BorQlm4SHC8
+6wXUU/TMAWjMzUS2jJ7VOVQ98y3KfzABZJh/0yV4DomuG3tCiAFunAv05wdbS7O
6EuWRd0M5g/nJqQzZw5ShcnR1+E9Hb8OZIg7n49WSgyxhMoqj636Ngabgpw3DM8Q
u/t7+WnNj1grbHV+aTJWwOpKXTUbvfGBFqv6dpXCIRBIOiostaD4VrAVHLIYSc+a
4CjliyN+Kh/p9lhwtptQi0mi0X3hzHDZ/qx6kTQBqgLNxdow9Y5vUoJGRZn1fZxb
8cMkPNd6siw/xMyVJFLK
=BJ0/
-----END PGP SIGNATURE-----

--LZvS9be/3tNcYl/X--
