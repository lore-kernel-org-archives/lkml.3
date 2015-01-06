Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324AbbAFMBx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 07:01:53 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:38035 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754558AbbAFMBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 07:01:51 -0500
Date: Tue, 6 Jan 2015 12:01:44 +0000
From: Mark Brown <broonie@kernel.org>
To: esben.haabendal@gmail.com
Cc: linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Esben Haabendal <eha@deif.com>
Message-ID: <20150106120144.GY2634@sirena.org.uk>
References: <1420538586-15867-1-git-send-email-esben.haabendal@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+0KmLy8UubQqhxHi"
Content-Disposition: inline
In-Reply-To: <1420538586-15867-1-git-send-email-esben.haabendal@gmail.com>
X-Cookie: What's so funny?
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] spi: fsl-(e)spi: Support compile as module
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+0KmLy8UubQqhxHi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 06, 2015 at 11:03:06AM +0100, esben.haabendal@gmail.com wrote:

> -#ifdef CONFIG_SPI_FSL_SPI
> +#if defined(CONFIG_SPI_FSL_SPI) || defined(CONFIG_SPI_FSL_SPI_MODULE)

This should use IS_ENABLED().

--+0KmLy8UubQqhxHi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUq86nAAoJECTWi3JdVIfQ84wIAIPOGKLGORndCrmRLXI7Niiv
bTF+A3h9piw+RYsfdjG4aZ04tNIdsOUVVvhUIn2bRQ7CJRNQJy14B/l+cScrSVUi
CBmKusi6QbKLV/7GhBauwEcSlX89bo3BlQTwXWGSOTgnRXZsEJcmtIzN+GpNYOS/
BdXVoCxod0JyN3vhkU9pYxsfmEFgds7aFi3GH6yjlEnBT2emniug+1CBOgaE5CH4
WaCh0NhPipj1kno1YnwlyatV5dFHL8JWNCgvH6D5Fa5flyxwwQSaLU1EV73h9JQ4
QGXARQH2T8e/I24PtjSc0lKRukzqtr+jZnDfhUNWfoAFqPZbpOaqokPNhyZeMgk=
=HslY
-----END PGP SIGNATURE-----

--+0KmLy8UubQqhxHi--
