Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752485AbaKYOJu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 09:09:50 -0500
Received: from sauhun.de ([89.238.76.85]:32810 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752453AbaKYOJs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 09:09:48 -0500
Date: Tue, 25 Nov 2014 15:11:14 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Grant Likely <grant.likely@linaro.org>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pantelis Antoniou <pantelis.antoniou@konsulko.com>,
        Rob Herring <robh+dt@kernel.org>, Mark Brown <broonie@kernel.org>,
        linux-i2c@vger.kernel.org
Subject: Re: [PATCH v2 11/14] i2c/of: Factor out Devicetree registration code
Message-ID: <20141125141114.GB1843@katana>
References: <1416868422-22103-1-git-send-email-grant.likely@linaro.org>
 <1416868422-22103-12-git-send-email-grant.likely@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="v9Ux+11Zm5mwPlX6"
Content-Disposition: inline
In-Reply-To: <1416868422-22103-12-git-send-email-grant.likely@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--v9Ux+11Zm5mwPlX6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 24, 2014 at 10:33:39PM +0000, Grant Likely wrote:
> From: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
>=20
> Dynamically inserting i2c client device nodes requires the use
> of a single device registration method. Factor out the loop body of
> of_i2c_register_devices() so that it can be called for individual
> device_nodes instead of for all the children of a node.
>=20
> Note: The diff of this commit looks far more complicated than it
> actually is due the indentation being changed for a large block of code.
> When viewed using the diff -w flag to ignore whitespace changes it can
> be seen that the change is actually quite simple.
>=20
> Signed-off-by: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
> [grant.likely: Made new function static and removed changes to header]
> Signed-off-by: Grant Likely <grant.likely@linaro.org>
> Cc: Wolfram Sang <wsa@the-dreams.de>
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: linux-i2c@vger.kernel.org

Reviewed-by: Wolfram Sang <wsa@the-dreams.de>

I'd prefer that this series goes through your tree. There is still this
merge conflict, but that is an easy one like I mentioned in my last
review.

--v9Ux+11Zm5mwPlX6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUdI4CAAoJEBQN5MwUoCm2bEgQAKNqVhNNFByIlg/xHSs3XcTj
G1sHlx4stUIWBjzuIWcniIlVAiGTkMV+kGeEH3xW9MxHwkCrqgjekVYmu0/ytlAf
S9zBZPBqJSrBIrE/qfL00bHxxFiXKC/K8ol8Gpu2v2fFb8u6DGOaAzwo6Ii5Wupu
3xL3tjdgMI3r4BZmhdbxRwoYD+T7hN7OxkEdZCVVz6MknWggmoABQX/fbsvZYRET
PZoQBBdWaHi1aiFXs1agllQk8ml/RA9dd2JFKnqF3Ma57ebcfo9rIVuc+Z8xoxuX
dCNhWih3+mI8uuWxtL4zj5STqn+rKgYgjNshHQYPrq/Pi/nwVJqYo1QZM70+Vptm
QkNvJvwmtoFt6jxc/W1yzLg7Y8IgBKRZBS8bR0Xgk6+EKCCyJ9ygxq9mMHNFieVn
j4i/h6sPRE9ZozrOvg1eqpRU7eoWlhSP4EQplf99IcwvprMLgXn7rrbOpk35CEy6
7vUdUifHer2mF3Uc8CWi5zCguKeiQIg2dXLzW5y2CofqFrHZRSLVKoAtNPR3oILV
yY2OJGXLeJPkO2Nn2sqk3fdID6Sk97XHqiVRvbLAotC/ofESa9lLoN4AaBRG0ALb
3tL0G7Uab0F1a79tn4vIAcMC4NVLOZ9An9/LBIawQtsKQwAp8IBQhnYENUpOV92E
QRTTeIlh53OzRmU0H6Gg
=hXTq
-----END PGP SIGNATURE-----

--v9Ux+11Zm5mwPlX6--
