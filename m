Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751348AbaGOEFN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 00:05:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44027 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750706AbaGOEFL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 00:05:11 -0400
Date: Tue, 15 Jul 2014 14:05:02 +1000
From: NeilBrown <neilb@suse.de>
To: Ian Kent <raven@themaw.net>
Cc: autofs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6 v2] autofs4: factor should_expire() out of
 autofs4_expire_indirect.
Message-ID: <20140715140502.5e7f1da0@notabene.brown>
In-Reply-To: <1405396113.3112.17.camel@perseus.fritz.box>
References: <20140709233541.4525.25151.stgit@notabene.brown>
	<20140709234114.4525.25725.stgit@notabene.brown>
	<20140714105359.4415aab4@notabene.brown>
	<1405396113.3112.17.camel@perseus.fritz.box>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/AlmQenZjwgtu/72Ak5Wgpw3"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/AlmQenZjwgtu/72Ak5Wgpw3
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 15 Jul 2014 11:48:33 +0800 Ian Kent <raven@themaw.net> wrote:
...
> So far I've tracked this to something that was introduced between 3.11
> and 3.12. One change that went into 3.12 was Jeff Laytons' umount
> specific path resolution for umount. I've found this is also broken on
> recent RHEL-6 kernels and that change is present in them too so the
> evidence is leaning toward that being the problem. Just how could happen
> with this change I have no clue so far, it just doesn't make sense.

Such a familiar story!  I've not yet failed to find bugs like that, but
sometimes it takes a looooong time.  Good luck!

>=20
> Anyway that's going to make testing these patches impossible until I can
> work out what the problem is and fix it.
>=20
> Very sorry to hold you up on this but it can't be avoided.=20

Thanks a lot for letting me know the situation!
While I always appreciate upstream review I've learnt not to depend on it.
I'll proceed with my customers based on my judgement and look forward to any
input you can provide whenever you are able to provide it.

Thanks,
NeilBrown

--Sig_/AlmQenZjwgtu/72Ak5Wgpw3
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU8Sobjnsnt1WYoG5AQKtDg/9GMUWIiCtkrG8rvxNenr9I9kVVf5XO9rP
hcmzzjybn1ts2DE/h7PvZBlYmGHoypEjxQodqSb/mqONXPoj0oyV4KWBCQ94wdbr
X1Xgv+MhPs8fjxv02w5VEkukbhGgKALi9J4UmWALsK0FyLrvYlq/cp+N9u7q8jxu
3GkmHmkO1GApQXCjxTmXSIAXeAo//rLAnNgfOKWVOWiiJZ5rjoCCsK6vG460eyMK
NdNIsSsb7Nzt5WI9Gsav6xkbYa0hbwPzHO7QVGzS0GojOWcbb41ULIKUZ+GQM8Ob
ztArt37A2osmaADWkRlWzMGbf8dlInHzQFhRY9svANyCxzUkQYd5VbMOtNM0taCN
6MBie11b2pQijmJP2oft2Tw5E5BPVXT/2IaGOGrgEAI0HMOjg9e5AeGR8XyMXF0i
UuDyuOZyeGj8BpTSV1Sk2spIroj0yfqx9vYOV+Ec8+jCW+Qb+xaTyZiEwCK2B4Y8
W7u0WEkF4pzzF3betsmqCFYiMBz7K7oGKPMp/9Q6dtZQjg+B2cEQVIrXjwOkOWZU
fknSP4/MnDieznlQ0gcmQgYT+VxPLavTak/S5Wd3W3gFGNHsI7CFYIGF0VK7UYEB
StTW50tpwXnmHul/X9Lmx3E5ECWZPgnU2UJXWPlx84thnAbDVHZp+RSM++WuwrkQ
dwGEc9rFpQ4=
=08UL
-----END PGP SIGNATURE-----

--Sig_/AlmQenZjwgtu/72Ak5Wgpw3--
