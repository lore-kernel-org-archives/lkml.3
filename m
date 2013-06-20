Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422682Ab3FTUfT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 16:35:19 -0400
Received: from sauhun.de ([89.238.76.85]:57129 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422653Ab3FTUfS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 16:35:18 -0400
Date: Thu, 20 Jun 2013 22:37:17 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Christian Ruppert <christian.ruppert@abilis.com>
Cc: Rob Herring <robherring2@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-i2c@vger.kernel.org,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Landley <rob@landley.net>, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>
Subject: Re: [PATCH v8] i2c-designware: make SDA hold time configurable
Message-ID: <20130620203716.GF2961@katana>
References: <51BF77C2.70004@gmail.com>
 <1371541469-20623-1-git-send-email-christian.ruppert@abilis.com>
 <20130620200454.GE2961@katana>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="p8PhoBjPxaQXD0vg"
Content-Disposition: inline
In-Reply-To: <20130620200454.GE2961@katana>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--p8PhoBjPxaQXD0vg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 20, 2013 at 10:04:54PM +0200, Wolfram Sang wrote:
> On Tue, Jun 18, 2013 at 09:44:29AM +0200, Christian Ruppert wrote:
> > This patch makes the SDA hold time configurable through device tree.
> >=20
> > Signed-off-by: Christian Ruppert <christian.ruppert@abilis.com>
> > Signed-off-by: Pierrick Hascoet <pierrick.hascoet@abilis.com>
>=20
> Okay, I am convinced of the property now...

and the version check is missing since older revisions do not support
sda-hold-time.



--p8PhoBjPxaQXD0vg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRw2f8AAoJEBQN5MwUoCm2I+4QALVjgDcgCz7SJB8UJVeVQObn
zBacERHocK5BF4D7lTmTs54B2uo2LnNYM2MGzexoPKb5yNPSJYEn7pJc68Vx7HVU
ipkDwN521MKLQEguc7KvaeV8ar814uBLsSIeUpQeB2OVuA0AjaPNNVB/KRQfhlCD
1eGyWiqohi7BEcl1ANghrkf208Yn4MBTv0qAL5ufwQrm8rourf+x+SxNy6hCVyad
jQnhh/LDaDk3y3/kbaPcfykl3jIXt+X5VSTXhmwi0fpTS17t6pon1ZJxcO6kwqvL
4JBrjCUhHhfOfWJtw4hYpy+B4A9plggGUXCKfblMyJmlmic8/ee07pRSpoVe+K8Z
jYN4hTxEVjZlyVt4EoiNhA3SV5HZB3olCUF9E/bgjOJcT2igMTTwdCpkxhyf1LY0
BRf9t/aggkG+rfKb3mU7/xCKEUvurvla2Ozvdk4YlKuCh6hBvL7W7X7m1+gWA/zx
p2/4xGHmeuP5gPkhWseIl7PGna+sJMo9GzNfjJ3ypB6vc3NPvUYQ8Hx6zSrZrk7w
E+XPyuoyIr8DPxaD0hOV6Tg8vSZLiSXz/siVr2OiytKew4sw4umAdFyLcsz9e4CD
drjirj26GqsDyimok4/yt/oM6jVLOI8lcVFRwIwIRLLUSzM8VkhcHOO2G2w5hSAE
axZCSiV9wwBpnwsaq1Gm
=uTow
-----END PGP SIGNATURE-----

--p8PhoBjPxaQXD0vg--
