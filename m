Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755067AbbATNUc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 08:20:32 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:54260 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755007AbbATNU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 08:20:28 -0500
Date: Tue, 20 Jan 2015 13:20:01 +0000
From: Mark Brown <broonie@kernel.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Inha Song <ideal.song@samsung.com>, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, sameo@linux.intel.com,
        ckeepax@opensource.wolfsonmicro.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Message-ID: <20150120132001.GA21293@sirena.org.uk>
References: <1420185829-24886-1-git-send-email-ideal.song@samsung.com>
 <1420185829-24886-3-git-send-email-ideal.song@samsung.com>
 <20150120122005.GA13701@x1>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="gKMricLos+KVdGMg"
Content-Disposition: inline
In-Reply-To: <20150120122005.GA13701@x1>
X-Cookie: My LESLIE GORE record is BROKEN ...
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [alsa-devel] [PATCH v2 RESEND 2/2] mfd: arizona: Update DT
 binding to support OUTn_MONO init_data
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gKMricLos+KVdGMg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 20, 2015 at 12:20:05PM +0000, Lee Jones wrote:
> On Fri, 02 Jan 2015, Inha Song wrote:

> > This patch update DT binding to support OUTn_MONO init_data. Each
> > output signal can be configurated as a mono differential output.
> > The mono differential configuration is selected using the OUTn_MONO
> > registers.

> This requires a DT Ack and an entry in the example.

The DT maintainers have said they're OK with maintainers just merging
things if they're comfortable with it (see the bindings specific
submitting-patches.txt) and given their workload and general resulting
responsiveness it's going to make it difficult go get anything done.

--gKMricLos+KVdGMg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJUvlYAAAoJECTWi3JdVIfQePsH/A2qysGVcmVKORiKU0eiv9it
Z5lW/OBk0Q/7JUcDijm+B8b4+h6ZRI4z/hh8NOTdj5KYyzO/Xt2m54BC6MRbfqvB
GgA3cU5TERnbmRDZ6w+XcBFnGTZ9GVCKCAPTDuqhBsFdHL4i51YMLJCOd7kx/wV5
a5UNVDyk6th03/upBEGGCxV1jR2k9+dfeawgfpZWfZB1kuzpj9tTBfZeOOdhwJW+
PP3QUgkK5UeTURCKdBgWfXK8km32ja94b3TP1cAKvrHB9m7N7SBcEBpUM4I1a0ej
zYHZQD6oI5AP+uz5CK69U1XWYYEPGcKhRYUCbgw1ptvdm2JhRwt6D487fC0pVcg=
=8xvF
-----END PGP SIGNATURE-----

--gKMricLos+KVdGMg--
