Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752383AbaCIIUz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 04:20:55 -0400
Received: from sauhun.de ([89.238.76.85]:51896 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751073AbaCIIUv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 04:20:51 -0400
Date: Sun, 9 Mar 2014 09:20:32 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Romain Baeriswyl <Romain.Baeriswyl@abilis.com>
Cc: rmallon@gmail.com, mika.westerberg@linux.intel.com,
        rob.herring@calxeda.com, pawel.moll@arm.com, mark.rutland@arm.com,
        swarren@wwwdotorg.org, ijc+devicetree@hellion.org.uk, rob@landley.net,
        pierrick.hascoet@abilis.com, vgupta@synopsys.com,
        christian.ruppert@abilis.com, chiau.ee.chew@intel.com,
        khali@linux-fr.org, rafael.j.wysocki@intel.com,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        romainba@abilis.com
Subject: Re: [PATCH v2 1/2] i2c designware make SCL and SDA falling time
 configurable
Message-ID: <20140309082032.GD2575@katana>
References: <20140116194303.GC4127@katana>
 <1390236223-22584-1-git-send-email-romainba@abilis.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yudcn1FV7Hsu/q59"
Content-Disposition: inline
In-Reply-To: <1390236223-22584-1-git-send-email-romainba@abilis.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yudcn1FV7Hsu/q59
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 20, 2014 at 05:43:43PM +0100, Romain Baeriswyl wrote:
> This patch allows to set independantly SCL and SDA falling times.
> The tLOW period is computed by taking into account the SCL falling time.
> The tHIGH period is computed by taking into account the SDA falling time.
>=20
> For instance in case the margin on tLOW is considered too small, it can
> be increased by increasing the SCL falling time which is by default set
> at 300ns.
>=20
> The same applies for tHIGH period with the help of SDA falling time.
>=20
> Signed-off-by: Romain Baeriswyl <romainba@abilis.com>
> Reviewed-by: Christian Ruppert <christian.ruppert@abilis.com>

Applied to for-next, thanks!


--yudcn1FV7Hsu/q59
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJTHCRQAAoJEBQN5MwUoCm2FJUP/17E0J+WUwcZkB4MWPXkGE/e
rs4EgmrjtGNIm52Xfvu/UYXe79t4i7ySxrPW5gz1VoBzGXg937i4BG8Piva+b7Z9
OFE59Nh4KpCEdBLyi8Wu/FfoCmDAwULK4qIk6fo1ofrAlA2KuAgSdSSXjY+y5MWL
S2tmBGmXcsBERbIYobcY9fAapbzE6f8TNutG5zARJOliievWjB21AW8lK2mxFKla
isoHEJQMPu/EnqvhCcDK2RfjmelrJyAZvulOkIicYeVY113vIn0QA+UBRiSQ0It0
I2bdlhGvuIzDlPRZAfcesCFQxPs1eXN7BzbsY2dFNJgJSf+CUB7EMQ7sx/OJ6GuW
ynU+mkwfLV8nNCOyVar5IH2VNMY4L+IBbmoE7ULKtLig4UNheFnZ8AKxEiIEYD5c
5OnlCCfxC8F9iKRrKGM8ttgM/V2tuP4GQWhMUttrLxh5KbS0jnpF4VJnPK7mXDUa
uF4Mcs+Bz09lj3FGl8MWAXyF/o4NdFHpZftwzL1i2yil5/jMFjILSA/UtL19JQWQ
Ka+dLf+yhEkY5zwUZ2kQU6vVekO4Zk1YVcKFc4tfIEQWznz35MnVAgo7vmjc2Y7K
89R2MM9b9C9waWgGNFZA+Dn3CiqHDV6ceYF6plp9DY7cD3fzKU7orE3oBqMFlyp0
omYfG2va9Sb1GM4sL3Xi
=iloF
-----END PGP SIGNATURE-----

--yudcn1FV7Hsu/q59--
