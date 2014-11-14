Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161565AbaKNRUT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 12:20:19 -0500
Received: from mail.kernel.org ([198.145.19.201]:34863 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161345AbaKNRUQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 12:20:16 -0500
Date: Fri, 14 Nov 2014 18:20:09 +0100
From: Sebastian Reichel <sre@kernel.org>
To: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>, Pali Roh?r <pali.rohar@gmail.com>,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        aaro.koskinen@iki.fi, freemangordon@abv.bg,
        Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: N900 modem support in 3.18-rc1
Message-ID: <20141114172008.GB12250@earth.universe>
References: <20141104205117.GA17606@amd>
 <20141106180335.GA21513@earth.universe>
 <20141106225005.GA14002@amd>
 <201411070001.46481@pali>
 <545C6F14.8050303@gmail.com>
 <20141113162420.GB8512@xo-6d-61-c0.localdomain>
 <5465A977.4030605@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="rJwd6BRFiFCcLxzm"
Content-Disposition: inline
In-Reply-To: <5465A977.4030605@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--rJwd6BRFiFCcLxzm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Nov 14, 2014 at 09:04:23AM +0200, Ivaylo Dimitrov wrote:
> [...]
> https://gitorious.org/linux-n900/freemangordons-linux-n900/commits/30e9a5=
c498a89cea4c29523f69e436bf0af3c631
>=20
> commits 89ce13b, b81d80d, ec4d0dc, 91256e2 and 8022a6d - e29f558 (no idea
> why gitorious shows those mixed with SGX stuff, on my local tree it is
> contiguous patch series)
>=20
> didn't test against the current upstream, but I see no reason why those
> should not apply, build and run.

The patch looks ok. It does not cleanup the cmt-speech driver for
mainline usage, but it should work. Before adding this driver to the
mainline kernel there should be open source userspace support anyway.

Btw. I am aware that this would break existing pulse audio stuff,
but wouldn't it make sense to export a V4L2 device instead of the
custom /dev/cmt_speech ABI?

> > >About the pulseaudio stuff - we're still in process of REing it, so
> > >far there are 2 out of 3 closed Nokia modules ready
> > >(https://gitorious.org/pulseaudio-nokia), but the last one, which is
> > >the one used for voice calls is still not ready and will take it a
> > >while :).
> >
> > Ok, is there a way I could help? Pretty much everything else works with
> > opensource drivers...
> >
>=20
> There is, though I am not sure you'll like it much - fire up IDA and join
> the party :P. Ping me on IRC for more details in case you're interested.
>=20
> Regards,
> Ivo

-- Sebastian

--rJwd6BRFiFCcLxzm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJUZjnIAAoJENju1/PIO/qaE50P/iBkVFblPfQxGzyPK8oVuapu
BPiWG0TklWFmqLup2Ghz1HAREn0AdK/Y7/H70groMYFOJTIU5kRWOkKIrArIK+4z
qgpZ+4iFa28/wSrxQFfQBDgYho5pjXQ+jdPtk922vtEeMfCtR8++d9AtQVngGGfl
kEpsJZtP74spTj5Sea688dsgqDotgFteTmtajkRIhaMlNVkn1maekGruQQ4NYLmn
8etl7oJoA8q9qPclDs2kzGjml9tTH5aaYo9l+wM4+raD1Bwrup+FhC+48NN38vjW
vFrJk1c47v/KAZKEnPs5YfFnDmWWgiqsoNIG6DqhcJ9R0AeT1cYQDXFHOVCg4Aln
6G91qaZsOK9pzuAoosmQtCt8oirkJhS1Z2oyPRaBPqiUi07puKQyrsytxn7ng26w
FqtVzvA1bqgUUZDjr0pZNlso+llTRxbDL4Hl/YFn3XsnVD55c1Oi/Srhy8M6UUbq
mCWbUaUbbX0RFKkl/8xu4cbwBLvr0sV+89+2E0Ff5QQ7HnKBNXGE6H6OZg5gBWLB
+64fagoRY7gROrJNCGdjjxnhtMItUwUswQsM9tY6HTlMa2L/UaVXk9puXjncyZuY
nXdL9HWFO8I7cK3/+hicfBmfXB3MPF54UxRzxDasBFFxb3gOyHmhugYdA02O6XAK
arlbP48/GBclxFvj+vTl
=XDRa
-----END PGP SIGNATURE-----

--rJwd6BRFiFCcLxzm--
