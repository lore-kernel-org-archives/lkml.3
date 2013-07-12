Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932474Ab3GLBDM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 21:03:12 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:55487 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932209Ab3GLBDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 21:03:11 -0400
Date: Fri, 12 Jul 2013 11:03:03 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Alasdair G Kergon <agk@redhat.com>
Cc: Yann Droneaud <ydroneaud@opteya.com>, Mike Snitzer <snitzer@redhat.com>,
        Robin Dong <sanbai@taobao.com>, linux-kernel@vger.kernel.org,
        Jim Ramsay <jim_ramsay@dell.com>, dm-devel@redhat.com,
        Mikulas Patocka <mpatocka@redhat.com>,
        "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
        Rob Herring <robherring2@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Milan Broz <gmazyland@gmail.com>, Guenter Roeck <linux@roeck-us.net>
Subject: Re: [dm-devel] [git pull] device-mapper changes for 3.11
Message-Id: <20130712110303.06095e7b41c49c35bcd61fab@canb.auug.org.au>
In-Reply-To: <20130711135522.GN8530@agk-dp.fab.redhat.com>
References: <20130711013448.GD32399@agk-dp.fab.redhat.com>
	<20130711162040.8a82cb97a6c647c4f61f919b@canb.auug.org.au>
	<20130711135522.GN8530@agk-dp.fab.redhat.com>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.19; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__12_Jul_2013_11_03_03_+1000_tYJy6HCLoj8f9sKQ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__12_Jul_2013_11_03_03_+1000_tYJy6HCLoj8f9sKQ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Alasdair,

On Thu, 11 Jul 2013 14:55:22 +0100 Alasdair G Kergon <agk@redhat.com> wrote:
>
> On Thu, Jul 11, 2013 at 04:20:40PM +1000, Stephen Rothwell wrote:
> > Alistair, is there some reason that you cannot maintain some relatively
> > stable git tree for me to fetch (instead of the quilt series). =20
>=20
> Well Mike Snitzer is becoming a joint maintainer and this also requires
> changes to the workflow so watch this space.

OK, noted.

> > Also,
> > there is not real reason to keep rebasing this stuff (especially just
> > before sending it to Linus).
> =20
> Most of the time the patches are decoupled from the rest of the tree
> and the final linux-next kernel is the same regardless of where the
> quilt tree is attached.  I maintain a single sequence of patches=20
> where the ones ready for upstream float up to the top and the
> linux-next export is a by-product and not the primary output.
>=20
> Anyway, like I say, we'll be changing things during the next couple of
> cycles and we'll bear your suggestions in mind.

Thanks, I will watch for developments.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__12_Jul_2013_11_03_03_+1000_tYJy6HCLoj8f9sKQ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJR31XHAAoJEECxmPOUX5FEVKMP/j1Y1hl23A+XOcKZqeHSqlo2
mWigXgDm1kB9vPPTzHDdOVoqnY7+vv9XGN78jleov/cS4C2uDUQ5gFMvn1PbvJBX
DdiOgyd8brlM8a3l1SFOGQ5qFOjNbrxkavWQ7pgle63hbPrtNdrAcbOxVDdrUGrn
3giKcu4oNlex7JUUihhuBo2yzyJOumo4tVSlIV+RFZqlzQd8mBZwT4r1r9mAxPbq
kPa1uR8qu4MRsEgjjpZV9cLwBtMxhKsMA6jYqGzccMfezbWX5dciz35pWvXhDMB5
Dk1uwP4W+yz0KDRLfzl4nR0dq1RGGTyQE9PioRkJG3cXJ4GUky1SczXtM/yPONhH
v3InRiJTWiVM8tDfWDXMuN0buQyRXdIP7aMS0AoPclvr4xdDnL23ZrDb1XjBEuaI
doODRcx6YxdMPF6wdbn8Rjc6gq5Y4Tz7wY9KwF4HRiFGdAmIqQVzLYKfZWLXTaSQ
Eb0AWnl9IjSmel3QuAz1KLrWWEyHTR8s3dAn/6L+YOxzZeYnyF56nJ1yuW43CZiP
aMVwgFZalR+8p+biVulMIp41XTi9XwsGri3dQWLv2uLGEgOXakkQygNyyJbMd8S0
Yjlfnm7kJZ5R5WA13dGgwwurQn8Dn/8qP5Q+sr9HDCD7092mN6S5nLsIKmJWzYY+
x+2ipYu7Jew9bmKyf0IT
=oHHk
-----END PGP SIGNATURE-----

--Signature=_Fri__12_Jul_2013_11_03_03_+1000_tYJy6HCLoj8f9sKQ--
