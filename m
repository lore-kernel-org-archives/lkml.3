Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753840AbaJTWh3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 18:37:29 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:45796 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751233AbaJTWh1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 18:37:27 -0400
Date: Mon, 20 Oct 2014 18:37:22 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/2] binfmt_misc: add comments & debug logs
Message-ID: <20141020223722.GA15168@vapier>
References: <1413759826-11958-1-git-send-email-vapier@gentoo.org>
 <1413765718.7076.3.camel@perches.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FL5UXtIhxfXey3p5"
Content-Disposition: inline
In-Reply-To: <1413765718.7076.3.camel@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FL5UXtIhxfXey3p5
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 19 Oct 2014 17:41, Joe Perches wrote:
> On Sun, 2014-10-19 at 19:03 -0400, Mike Frysinger wrote:
> > let's deploy extensive pr_debug markers at
> > logical parse points, and add comments to the dense parsing logic.
> []
> > diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
> []
> > @@ -259,14 +270,17 @@ static char * check_special_flags (char * sfs, No=
de * e)
> >  	while (cont) {
> >  		switch (*p) {
> >  			case 'P':
> > +				pr_debug("register: flag: P (preserve argv0)");
>=20
> Missing '\n' newline.
> Can you please add them as appropriate?

hmm, guess i was relying on pr_cont behavior to do the right thing.  will d=
o.
-mike

--FL5UXtIhxfXey3p5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJURY6iAAoJEEFjO5/oN/WBdJEP/jYUcRl3TrTUJV1VUmQ2WRkS
IWKe7rrFcHcpN17qoIQ7yA/aasQxV52GpEGyAOx0e9JF2EOFho40a4KHoHYoyvDF
6/0UlgZb3GsFOzdoMQsyoB6+k+pO/6cbx6AAxI/whGu8YMos4Tql+xxPBGYZjPVN
+g6Wug7ySU6aDbSU++1XH8MbXKcgIJy35NujK37KPVBzCSsd5f+tagTP3/3nbBwt
KFmF215IOnG2jLbsD0pG0iPMPfM2IiPRK1vFD/Kv56hGpZ5/qkTIH+aSKGv/XHw+
lS0obq7vG29kihVnekwoDKU/IjIxmroJaD3KQKRbUW1GkulkYQeugUd8jCDd2VCM
eo4qYdoitfUmfsuToDlz4f8tiUIEJephGSTUODpvUG1hNSed24710cAPzNMnsz9d
aNZLRGiconxO/d3M5CJNJA8R4EtSvb3z+/dhHzT1awy4A3zdIl6PVGdr/1vpvvsM
QJZu70MrQ0ypxPANlrR67Wq/w9kjnuOmq+lBwx7Egh+bYOkUrSrXHozc40WVBWHe
nK5GUKW/KadKcOolDX3FjqbIkg1RXNswXKhm41tprhhAFG//xa32MB33qqS8I0SZ
VAlkZO5V+x2+5fuCyiQn4RosekCpko2mIKzufI8jNHqHWKWs+9SF1zfpE0/FTK2I
a5Xj4hxtCwkqv6dyKseG
=knjt
-----END PGP SIGNATURE-----

--FL5UXtIhxfXey3p5--
