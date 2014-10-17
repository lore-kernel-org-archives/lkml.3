Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753076AbaJQPbm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 11:31:42 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:51233 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752032AbaJQPbk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 11:31:40 -0400
Date: Fri, 17 Oct 2014 10:31:24 -0500
From: Felipe Balbi <balbi@ti.com>
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>
CC: Kishon Vijay Abraham I <kishon@ti.com>,
        Vivek Gautam <gautam.vivek@samsung.com>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <andrew.kim@intel.com>
Subject: Re: [PATCHv4 1/6] phy: safer to_phy() macro
Message-ID: <20141017153124.GO26260@saruman>
Reply-To: <balbi@ti.com>
References: <1413556756-5050-1-git-send-email-heikki.krogerus@linux.intel.com>
 <1413556756-5050-2-git-send-email-heikki.krogerus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nljfjKcp9HDtPSOP"
Content-Disposition: inline
In-Reply-To: <1413556756-5050-2-git-send-email-heikki.krogerus@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nljfjKcp9HDtPSOP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 17, 2014 at 05:39:11PM +0300, Heikki Krogerus wrote:
> This makes to_phy() macro work with other variable names
> besides "dev".
>=20
> Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> Tested-by: Vivek Gautam <gautam.vivek@samsung.com>

Acked-by: Felipe Balbi <balbi@ti.com>

> ---
>  include/linux/phy/phy.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/include/linux/phy/phy.h b/include/linux/phy/phy.h
> index 8cb6f81..9fda683 100644
> --- a/include/linux/phy/phy.h
> +++ b/include/linux/phy/phy.h
> @@ -110,7 +110,7 @@ struct phy_init_data {
>  	.port		=3D _port,				\
>  }
> =20
> -#define	to_phy(dev)	(container_of((dev), struct phy, dev))
> +#define	to_phy(a)	(container_of((a), struct phy, dev))
> =20
>  #define	of_phy_provider_register(dev, xlate)	\
>  	__of_phy_provider_register((dev), THIS_MODULE, (xlate))
> --=20
> 2.1.1
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

--=20
balbi

--nljfjKcp9HDtPSOP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUQTZMAAoJEIaOsuA1yqREyBYP/iOkwwc3v4ESxDoujcut0rTZ
fJ8Vvaa42c014BpeQvS1I6ljWs2dnOSxJB1q+7JwjThpECtN8xjtB1c/lL8yoYL1
HZwf/Sz+sUzHTEAUYGLTmAR2+cyXmkOnKlDYTsu9mwZJ6rMyVy6fteynxXbSj+VP
wyhErgt1KMx0dswBdnUenKI6THBP93Gt3OeG9WjSTewkKFFgj5cDFi7qdOZzKiQP
wXQ4hfpqutiY1+TIByXBjeXtYfNiYliRGzzjs6nM9EOO92FtVuePA1EEqgvgdCDy
+g0NrGkcRSRd81AaICu3LIcnGPDjiz01iwofBjgfjRr3Jol5a2wrYNfXTckwk6xX
Ym37o1jjqXX17BqV4O7cBJUqVgaSTo7ftaTZ+W1NaQ52eq15r3cqCnxhv9AGW7pt
L0EcWn+Aj1N8NU+swBRxKxLPAm60YhLiZgWBBDWMU85Mh8T2OALL1OHUrSVwpXF+
tyGoEuMrj8D0HosyzxuzgRSjYUmpWh7TTFjAxVOGMIGfowJMh1e8NUJ6vSNHgb/R
RhY5zuiLh0kjDsps0D24iOwuj5Md4W1CA2NC0YmbGuS6VovpNNkhVrj8rYu835ZE
AxVgxJlZ9ml4v1Hsjz9aBxzcfX8W1aUk5FeYw3gSRSYDl5w8lW6I0FifW/upjVWA
aB69PBy5pWb2/ruVC0Ku
=VBnb
-----END PGP SIGNATURE-----

--nljfjKcp9HDtPSOP--
