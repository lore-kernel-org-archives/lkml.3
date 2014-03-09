Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752517AbaCIIyH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 04:54:07 -0400
Received: from sauhun.de ([89.238.76.85]:54824 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751398AbaCIIyE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 04:54:04 -0400
Date: Sun, 9 Mar 2014 09:53:58 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Chew Chiau Ee <chiau.ee.chew@intel.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] i2c: designware-pci: add 10-bit addressing mode
 functionality for BYT I2C
Message-ID: <20140309085357.GA4695@katana>
References: <1394201571-11681-1-git-send-email-chiau.ee.chew@intel.com>
 <1394201571-11681-2-git-send-email-chiau.ee.chew@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YiEDa0DAkWCtVeE4"
Content-Disposition: inline
In-Reply-To: <1394201571-11681-2-git-send-email-chiau.ee.chew@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--YiEDa0DAkWCtVeE4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 07, 2014 at 10:12:50PM +0800, Chew Chiau Ee wrote:
> From: Chew, Chiau Ee <chiau.ee.chew@intel.com>
>=20
> All the I2C controllers on Intel BayTrail LPSS subsystem able
> to support 10-bit addressing mode functionality.
>=20
> Signed-off-by: Chew, Chiau Ee <chiau.ee.chew@intel.com>
> Signed-off-by: Ong, Boon Leong <boon.leong.ong@intel.com>
> ---
>  drivers/i2c/busses/i2c-designware-pcidrv.c |   17 +++++++++++------
>  1 files changed, 11 insertions(+), 6 deletions(-)
>=20
> diff --git a/drivers/i2c/busses/i2c-designware-pcidrv.c b/drivers/i2c/bus=
ses/i2c-designware-pcidrv.c
> index f1dabee..87f2fc4 100644
> --- a/drivers/i2c/busses/i2c-designware-pcidrv.c
> +++ b/drivers/i2c/busses/i2c-designware-pcidrv.c
> @@ -64,12 +64,19 @@ struct dw_pci_controller {
>  	u32 tx_fifo_depth;
>  	u32 rx_fifo_depth;
>  	u32 clk_khz;
> +	u32 functionality;
>  };
> =20
>  #define INTEL_MID_STD_CFG  (DW_IC_CON_MASTER |			\
>  				DW_IC_CON_SLAVE_DISABLE |	\
>  				DW_IC_CON_RESTART_EN)
> =20
> +#define DW_DEFAULT_FUNCTIONALITY (I2C_FUNC_I2C |			\
> +					I2C_FUNC_SMBUS_BYTE |		\
> +					I2C_FUNC_SMBUS_BYTE_DATA |	\
> +					I2C_FUNC_SMBUS_WORD_DATA |	\
> +					I2C_FUNC_SMBUS_I2C_BLOCK)

Can't we have I2C_FUNC_SMBUS_EMUL here? (Need checking with
I2C_SMBUS_QUICK)


--YiEDa0DAkWCtVeE4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJTHCwlAAoJEBQN5MwUoCm2B6sP/32n+bq57zW4khi/abZKdUyW
g+cK31cudfHOdUzzNAcixOqTq2DgkfDZViIP9D2Cum/suFCqjebjpIEtnkbjdfav
xsXtAM+8XrS2biv2Wd7wXg6iW0n1UoHyl+bz57yYr8ZiXlI6lcwSuL4hKlgZA4Lm
fw4jvn5GNz5lXZua8Fh3XE2uT43ViVO8Gx6EPZZsD+0wgXn8zBj37NAXtA5ENRRW
vdwsRChNT00d9XNi3yhDfujhNbvK8Xfit91vWxTejsakpwkNt68NBDB5Gl4aDfq4
oe/iv6Qzs3z8syyNnoSca3z/DbFSVQCnFGiVUiILpLHWzTSMVD7J7anxcFgRcy8R
eNqtpEeEHPGysKNWBtdkzRvAIJDzPF4qcFRPz0Nx7AiKQcNH+wHHvHOMWOnCqq8l
282z3WGHaOJnC7qQ0mWOwbLi/R0QhigCbuK0VHB9h1RDzqOfr26tpjOStr9V2f9v
rvpkRF55g4YXeJ4HEAdpDP7t0YiPX1AwE/A3Po9I0s7jIb1EZXcDbmw6NyC2DjT6
J1dQ+IazPcRybpDHxyXVvZUXm3Fqh7ArjQ6r0R9ONjJ2vTJ6W635N7JJJHzfRpYy
QG9h/CcqU23G2fjlA+F/vH0kckZdHXDFBj0+mtZLfrUrPmkfO+LHB9vYKQbNRb2I
PF8FqBSIzq18NRe7V3Bq
=v7HB
-----END PGP SIGNATURE-----

--YiEDa0DAkWCtVeE4--
