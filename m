Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751159Ab3K3SO7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 13:14:59 -0500
Received: from ring0.de ([91.143.88.219]:36493 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750739Ab3K3SO5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 13:14:57 -0500
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	*  0.0 URIBL_BLOCKED ADMINISTRATOR NOTICE: The query to URIBL was blocked.
	*       See http://wiki.apache.org/spamassassin/DnsBlocklists#dnsbl-block
	*      for more information.
	*      [URIs: linaro.org]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
Date: Sat, 30 Nov 2013 19:14:54 +0100
From: Sebastian Reichel <sre@debian.org>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Documentation: DTS: bq27xxx are trivial i2c devices
Message-ID: <20131130181453.GA15492@earth.universe>
Mail-Followup-To: Wolfram Sang <wsa@the-dreams.de>,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1382446577-28270-1-git-send-email-sre@debian.org>
 <20131025195634.EEBECC40531@trevor.secretlab.ca>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="LQksG6bCIzRHxTLp"
Content-Disposition: inline
In-Reply-To: <20131025195634.EEBECC40531@trevor.secretlab.ca>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LQksG6bCIzRHxTLp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Wolfram,

On Fri, Oct 25, 2013 at 08:56:34PM +0100, Grant Likely wrote:
> On Tue, 22 Oct 2013 14:56:16 +0200, Sebastian Reichel <sre@debian.org> wr=
ote:
> > Add all chips supported by the bq27xxx driver to the list
> > of trivial i2c devices.
> >=20
> > Signed-off-by: Sebastian Reichel <sre@debian.org>
> Acked-by: Grant Likely <grant.likely@linaro.org>

Can you take the Documentation patch [0] through your queue?

[0] https://lkml.org/lkml/2013/10/22/149

-- Sebastian

--LQksG6bCIzRHxTLp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBCAAGBQJSmisdAAoJENju1/PIO/qa0M4P/iPn6LsPTszIObMTcNsUOL+9
3bWt0zG+5sajLJXLNVc5BavryM9QJ80EsNFT00ne11888oO0RvrhX5d5tvnFH6Lw
IjSXqgNX5M15uvemdaxQVVM7zUBNWNYl6z+NjRixtr0fznBsdEOzW+36eqgNrtuj
zq/5eLSPVLXw9+yM7soqyac1il21s+cVpJIUkZmFEqgu6pBIcfhdaPsHoiM8lsYf
Gf6LmKZ3NPOANQ/vF02hGvCh1fgL705CyEGST/QITkbkZfpEjEHYaOyzC2VeSB82
QRWtkbts8fLIkZq8zpsvzBAsNRsKChbjejM0pFlAPFusZFBgLhOYRQC9VREGg12L
PS4xY1PK7OVPQUdJTYMagH5M6EovCGZnZvs60w+wD/KO2HSumH5KPDs+f33XuO6x
hKs5sCyTHMf/GidST8lL+pY62RlKW/o4XUUxJfBUezBwjUgtxeFEU9G+pj69Omt+
cpjnv50dmohOQYskSuTJ5b3/C7PEdhtNofvUGoA+kLIvPotSiu/XUnvJAb9pNFPu
dbItUEhswQCEZzitn4mZCZPCzji/M66BNzKuvNHvUkbX8Qrp26lLa4C3wLD1FSOZ
0nAGseggZu8swQlakFTwKKig/crTZaNCSEH6jNxPN4aN5e+74GYjY9RTpy8Wj98B
h48R6VwVl//szNYXWJMt
=wWks
-----END PGP SIGNATURE-----

--LQksG6bCIzRHxTLp--
