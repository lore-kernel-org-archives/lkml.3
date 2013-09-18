Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751505Ab3IRDD4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 23:03:56 -0400
Received: from ozlabs.org ([203.10.76.45]:34879 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751054Ab3IRDDz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 23:03:55 -0400
Date: Wed, 18 Sep 2013 11:25:57 +1000
From: David Gibson <david@gibson.dropbear.id.au>
To: Frank Rowand <frowand.list@gmail.com>
Cc: Olof Johansson <olof@lixom.net>, Tomasz Figa <tomasz.figa@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Stephen Warren <swarren@nvidia.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: "memory" binding issues
Message-ID: <20130918012557.GA22725@voom.fritz.box>
References: <1379300274.4098.77.camel@pasglop>
 <1379371567.3721.46.camel@pasglop>
 <CAOesGMgE1jiF5OHsmPQz2z66Bcqu0HeAj=taE1vmFK-0-0s2TQ@mail.gmail.com>
 <1815499.tpfeUKmP6V@flatron>
 <20130917164307.GA31327@quad.lixom.net>
 <5238C4D1.6060500@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jI8keyz6grp/JLjh"
Content-Disposition: inline
In-Reply-To: <5238C4D1.6060500@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jI8keyz6grp/JLjh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 17, 2013 at 02:08:33PM -0700, Frank Rowand wrote:
> On 9/17/2013 9:43 AM, Olof Johansson wrote:
> > On Tue, Sep 17, 2013 at 09:56:39AM +0200, Tomasz Figa wrote:
> >> I'm afraid that I must disagree. For consistency I'd rather go with wh=
at=20
> >> Ben said. Please see ePAPR chapter 2.2.1.1, which clearly defines how=
=20
> >> nodes should be named.
> >=20
> > 2.2.1.1 is there to point out that unit address _has_ to reflect reg.
> >=20
> > 2.2.3 says that unit addresses can be omitted.
>=20
> 2.2.3 is talking about path names.
>=20
> 2.2.1.1 is talking about node names.
>=20
> 2.2.1.1 _does_ require the unit address in the node name, 2.2.3 does not
> remove that requirement.

Certainly the recommendation I've been giving from the early days of
ePAPR has been that a node should have a unit address if and only if
it has a 'reg' property.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--jI8keyz6grp/JLjh
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJSOQElAAoJEGw4ysog2bOS0wQQALnP5TvQEcyHQQE8hC5yTQPp
FoXt750ascj1bEI598dNXsCCQ4IvOHaaVYQld/DPNozLFORvF4noUq9riFw5Zbtz
JbpCgjSOmrrrhT8OGTkTFgaIrSvIv9ZR5zKFgmO4Yf7msg8O8K9g1NmlokoXny/r
1iNBdPL7o+YeiZaNKWSxjy1VQicZwz/NWYIbudUkfe2Wz7Em+EM3hKCmIYgGUFKB
aeNjwdLnlLJ9+QRK0fNw0o4HNfsuGYInIPTp1zha1r8PPVBl/QEt0IJCWiYXrtiB
mUgXroYG3mplkMEotQ94ny5MHSZ3lU3k0RvH+jrpn890qPukZxNHf6u+ScG/zXjs
HcuUi77ORFqKsmCP4JtLVndG2zuP2Mi+msFfaol+3k2HxYxeDhlUHhPC/gOkl278
DFATo2jSO2SjVlM4dDyP7c9JsqxEAzeTrNazcTMelDUEOSir8FHKbN+U1ZegBnEj
DToWhcAV/DlleUV4g4zx+sei2wWZLQrq+BtxxBC9BnoSI6w2+F9876abs0XF4G44
WYyaUMbXVisY2x+ZoXNzt8a+mNOBNWM7t4ejhRoBbbhn4fU8WszbN9gW4Ip6HfI8
UQ1L6XuSs6tPKAYlyt8KE+9CEH7WfsF4UkKojMGeUPir4x7xNqz+Ek1XVE5uU7XN
wFDEyOrG/DplJ2Yl+O13
=7HU7
-----END PGP SIGNATURE-----

--jI8keyz6grp/JLjh--
