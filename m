Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751370Ab3FNEMN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 00:12:13 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38424 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750906Ab3FNEML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 00:12:11 -0400
Message-ID: <1371183115.10688.78.camel@deadeye.wl.decadent.org.uk>
Subject: Re: Linux 2.6.32.61
From: Ben Hutchings <ben@decadent.org.uk>
To: Willy Tarreau <w@1wt.eu>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Date: Fri, 14 Jun 2013 05:11:55 +0100
In-Reply-To: <20130610101557.GA3235@1wt.eu>
References: <20130610101557.GA3235@1wt.eu>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-AKVFywMXk3iaD1IquuZ5"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-AKVFywMXk3iaD1IquuZ5
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2013-06-10 at 12:15 +0200, Willy Tarreau wrote:
[...]
> Eric Dumazet (8):
[...]
>       softirq: reduce latencies
[...]

This one apparently introduces a regression, fixed in mainline by commit
34376a50fb1f 'Fix lockup related to stop_machine being stuck in
__do_softirq.'

I'm a bit surprised that you picked it for 2.6.32 as it wasn't applied
to any other branch older than 3.9.

Ben.

--=20
Ben Hutchings
If the facts do not conform to your theory, they must be disposed of.

--=-AKVFywMXk3iaD1IquuZ5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUbqYC+e/yOyVhhEJAQojaBAAjvRn/DVpJFg3Fuf5NvJOQnxtlz/ZOxu1
BENWszZipE9kMm7kt/ReY4wt/vXx4V4/ucA81HzP6Cyg/GGMFoMSac19HMJ5vg+9
/tswFfcD5gv9rIhC2WoIPUXbtnIec56TjGDWjGynxEvhV5heW5Dn0YEbunknEU1c
OONBetWoIRZmYFlypHfwhYDXIntc23HVwOWW8wyVwOBiHNPdn+twzDRuSfGi75N7
nLTrTl7l+vMAG23p2ZTeC6AnuAkATNOv755zXikTe8DNK15wdrrC/FzAYQE1l2Mr
qLIb+r9wnRN61mdkniwzw30FCWtkVrm54n3vUs1VQNcc2WVC6GjYYr+4gzCAArg2
f7WgQemVO4ydMuBqtpu/JSxsryl24fPhQF2tFStMzaVVHNqVMnryjwg3IenRQnRx
Y++Vj5BRrZaUp32XM2a0sow9kI/q2yoqL4A78NuuYOz/Tt8dnlQGLwdCw8lAMlI3
T9xyGp5lR8lvTyTqViV1tHcDBcOlAOeMiEMiFJXgyKUGk5d39sBLbTs/8IyrPwZb
YomjvG1p6wBFpgRKzgFgnIpOpbeaUsEYb9IdITHPsk6H3kKny7Ai5h2JlQzCtNta
L1fhaS+zv2Zk8bYg28u6j2EjtIYQfyw67/SgVhcT65AkTLCX10EZjWFe2OG4L+np
rYaUbmVateE=
=tuJQ
-----END PGP SIGNATURE-----

--=-AKVFywMXk3iaD1IquuZ5--
