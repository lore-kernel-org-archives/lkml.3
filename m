Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755885Ab3KWMGS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 07:06:18 -0500
Received: from ring0.de ([91.143.88.219]:55656 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751943Ab3KWMGN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 07:06:13 -0500
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	*  0.0 URIBL_BLOCKED ADMINISTRATOR NOTICE: The query to URIBL was blocked.
	*       See http://wiki.apache.org/spamassassin/DnsBlocklists#dnsbl-block
	*      for more information.
	*      [URIs: lkml.org]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
Date: Sat, 23 Nov 2013 13:06:06 +0100
From: Sebastian Reichel <sre@debian.org>
To: Jonathan Cameron <jic23@kernel.org>
Cc: Grant Likely <grant.likely@secretlab.ca>, linux-iio@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Jonathan Cameron <jic23@cam.ac.uk>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bill Pemberton <wfp5p@virginia.edu>,
        Sachin Kamat <sachin.kamat@linaro.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iio:light:tsl2563: Add DT support
Message-ID: <20131123120606.GA21861@earth.universe>
Mail-Followup-To: Jonathan Cameron <jic23@kernel.org>,
	Grant Likely <grant.likely@secretlab.ca>, linux-iio@vger.kernel.org,
	Rob Herring <rob.herring@calxeda.com>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Rob Landley <rob@landley.net>, Jonathan Cameron <jic23@cam.ac.uk>,
	Peter Meerwald <pmeerw@pmeerw.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Bill Pemberton <wfp5p@virginia.edu>,
	Sachin Kamat <sachin.kamat@linaro.org>, devicetree@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1382565063-17083-1-git-send-email-sre@debian.org>
 <20131025191028.8C140C40422@trevor.secretlab.ca>
 <20131025230906.GB8657@earth.universe>
 <52909685.6040606@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="4Ckj6UjgE2iN1+kY"
Content-Disposition: inline
In-Reply-To: <52909685.6040606@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4Ckj6UjgE2iN1+kY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 23, 2013 at 11:50:29AM +0000, Jonathan Cameron wrote:
> On 10/26/13 00:09, Sebastian Reichel wrote:
> > Hi Grant,
> >=20
> > On Fri, Oct 25, 2013 at 08:10:28PM +0100, Grant Likely wrote:
> >>> +  - cover-comp-gain : integer used as multiplier for gain +         =
             compensation (default =3D 1)
> >>=20
> >> Should be taos,cover-comp-gain
> >=20
> > Has been updated to "amstaos,cover-comp-gain" in the latest patches, se=
e https://lkml.org/lkml/2013/10/25/59
> >=20
> >> Otherwise looks fine to me.
> >=20
> > Is this an acked-by?
> It's good enough for me to take the patch  :)
> >=20
> >>> +	else if (np) +		of_property_read_u32_index(np, "cover-comp-gain", 0=
, +							&chip->cover_comp_gain);
> >>=20
> >> of_property_read_u32() should be sufficient. You don't need the _index=
 variant.
> >=20
> > ah, I missed the function when skipping over linux/of.h. I will sent an=
other update.
>
> Did you do this? Latest I seem to have is V3 and that doesn't have
> this change.

Sorry, I forgot, that I still had work to do for this patch :(

> I've made the obvious change to your V3 and applied it.

Thanks for taking care of it.

-- Sebastian

--4Ckj6UjgE2iN1+kY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBCAAGBQJSkJouAAoJENju1/PIO/qa9J4P/iOU2SZH78u/hdaMUWsANdPU
eXexPX7duUQAMn3Uxfi91k7Rgtob7VAJ9CZF2josPHqFak0moky4WRpydlqj55XH
tJFIFlXPfZPvTNdkWpJFNOFX438Hz9wcrZuzfUKwXrUANRp9gzS4f4T35yrsFro2
EzOTjHSFhn51l5YUL1/77fasRX2khAXb+jW458uvL7LCKRUhKXTQwd773Q43zyTQ
7OMXnri4exJFj8YcHtKkDnxvbZFLqvM5Gh8zMfxQ8V4pmSuqZauyFVTEpBS3rW1A
8vOPJTvsB9V81vQdnjA+Me6TNGvDoaoPlrMqVjKnpdjuaqd57DgGS9jYcxloEUoL
xAOr+D5kkAAQUm9TS5ESaEU2mGf2XQZ/1FvK412kD2AT8C6pRLNaFRl4KIa2tkOe
sG/rkImVA6bMvp6qv+L7TiPexbL+x/d2RPxJNYY2rFtf7tqm/BGJFrAYvo5h/9bw
T/edFds+Y87KrLv1Vq3LRnuGiRma+cepiMqh8ooSfUFXNwLvWU8RE8HwZ78DWYO2
9d51kbZoVhQruJgXDmWv4H3+AA7e3tLRcXja5QinP4si4GXsSlaOb6qhrmXmD2Yp
DS4ct8GA1BM7eOs+wE699lsQvQzvGZFb+ZZUZ0xzlFJe6yaV9xNGMvQPcea2BZE3
W/bAkO7/9AbAao5A9gu8
=O9Sy
-----END PGP SIGNATURE-----

--4Ckj6UjgE2iN1+kY--
