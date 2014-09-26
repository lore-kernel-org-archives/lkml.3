Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754312AbaIZIjp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 04:39:45 -0400
Received: from ozlabs.org ([103.22.144.67]:42567 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753732AbaIZIjm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 04:39:42 -0400
Date: Fri, 26 Sep 2014 18:39:35 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Carlo Caione <carlo@caione.org>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Krzysztof =?UTF-8?B?SGHFgmFzYQ==?= <khalasa@piap.pl>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: linux-next: manual merge of the arm-soc tree with the arm tree
Message-ID: <20140926183935.4a4eec89@canb.auug.org.au>
In-Reply-To: <CAOQ7t2Z8SgjMMM_QgUuAgezMXDBYyJM4kez-3WzGE4jgutjX6g@mail.gmail.com>
References: <20140926112344.3ee87d2f@canb.auug.org.au>
	<CAOQ7t2Z8SgjMMM_QgUuAgezMXDBYyJM4kez-3WzGE4jgutjX6g@mail.gmail.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/2WMXvzKSeSmnJ6kAj/9srmc"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/2WMXvzKSeSmnJ6kAj/9srmc
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Carlo,

On Fri, 26 Sep 2014 10:19:43 +0200 Carlo Caione <carlo@caione.org> wrote:
>
> Am I going blind or these two lines are missing from d8a00916b303
>=20
> +       default 0xc81004c0 if DEBUG_MESON_UARTAO
> ...
> +       default 0xf31004c0 if DEBUG_MESON_UARTAO

They are in the final version of arch/arm/Kconfig.debug, just not shown
in the conflict resolution above.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/2WMXvzKSeSmnJ6kAj/9srmc
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUJSZLAAoJEMDTa8Ir7ZwV/BUP/j7DXwan84p26bUhLQnd3UNd
OrV1qi+zOQtDWdhoWJ+7qxBZ+jdzbitZs5YnwS7YU++SdOl5VYxD0ILFkXnlPcGO
PDruDmA8ehJfLe4zwpZwAK+/zDRz2DFVD20BNa2c+VPK3VhKz20HujjDVxTfy0OM
CtfvOwbq0BBjDJ+wOrBdhfZOnPxsStbxxhYcBmVa5O9Wh9lm7ADoNeSb33Q8bVrJ
DDQzXBTFfRd566xWm57DjrULsPe6s9NPXRg8c/F6Iz65qwe1o+GZ+4SJiaKSK6p9
lWKK/RR0PdTK0YNFeWMw0rqf2LuxlAorNvyWOA1sYmdt3teCMJX2nP4AV/Hu7hQU
rCDeUt4VVPgYPLyvf46Y3MMU3kETgXh5/161RUPLaqidEmyaeqfEnkJIB7/ncaJ2
WaPGSBEPyOwdGCV3r6Z1DweFfceh5jKohgij8S+F1EMGGbfWGblaJhXxOUHhuRZO
Zco6weOGNfIijr/pPgM9I3lYjBHOB8ACHTWR4Wyd7q33qmE0cTs31zjgxEa0W+PU
+jpADUyGJ/1O6XBMWmpaLqlL8NiAFXDCA6+601Bvjf2ZKAJb35TPvYMjOHJXq+s3
/vkrC3nkTNtY7/ZwIs+uvmW4/bvys3KFVu3jix3QvCdzluUJOf5zyDwSmX+rlnjU
1Z+b1TZnf6m66sWAZNvc
=Rec5
-----END PGP SIGNATURE-----

--Sig_/2WMXvzKSeSmnJ6kAj/9srmc--
