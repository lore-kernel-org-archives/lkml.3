Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752128AbaIMPj2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2014 11:39:28 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:39095 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751976AbaIMPj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2014 11:39:26 -0400
Date: Fri, 12 Sep 2014 11:14:42 +0100
From: Mark Brown <broonie@kernel.org>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        wsa@the-dreams.de, sjoerd.simons@collabora.co.uk
Message-ID: <20140912101442.GR7960@sirena.org.uk>
References: <54119DB6.8020807@collabora.co.uk>
 <20140911193325.GT4015@sirena.org.uk>
 <5412C1DF.3040707@collabora.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6eUvXotnMb6+obQB"
Content-Disposition: inline
In-Reply-To: <5412C1DF.3040707@collabora.co.uk>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 209.49.225.226
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: SPI and module auto-loading
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6eUvXotnMb6+obQB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Sep 12, 2014 at 11:50:23AM +0200, Javier Martinez Canillas wrote:
> On 09/11/2014 09:33 PM, Mark Brown wrote:

> > I'm not sure I see that as an interesting use case, it seems better to
> > have drivers usable without DT and it's trivial to do so.

> Yes, it's trivial but seems like an unnecessary duplication for me. AFAICT the
> OF tables are only used to match the devices in spi_match_device() but if both
> the OF and SPI tables must be kept in sync to properly report the module
> aliases to user-space then I wonder if the OF tables shouldn't just be removed
> from the SPI drivers since spi_match_device() will succeed anyways when
> calling spi_match_id().

The vendor identifier is an important part of the OF device ID, vendors
can and do end up with different devices of the same name.

--6eUvXotnMb6+obQB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUEseRAAoJECTWi3JdVIfQLgIH/3mMnuTYaQ0by3BYj4TI7PED
4Yttr0iYsNtUz/X070ERIAHgFULpgapFrOdTrdlCS4juYORZVVjYzQA0Xad6UMux
+4apRJ/k7/MkIt7HbR36gc+ADidmgFGGvLULMUezdjpvIVnO38w6AEMwdV33dofO
sdhc/GgcZGnQpKTdORBRt0i07Ql0vjEDDwoLqoHqBznAxoE7Zga7U643cPlwb9md
aZg+LAI8BmNaVVEp0vvpLDc+0nP1CcnMt3tDlhSATvqfBcHt/rl9+YFCzlBWK8gt
zt+B9s+T2Rm966QyVqa5/ICkHu9mCbzoWrpftRX2gGfxFSwwnARVcWA5TPabGck=
=sAgB
-----END PGP SIGNATURE-----

--6eUvXotnMb6+obQB--
