Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757213Ab3DWSa2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 14:30:28 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52647 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756920Ab3DWSa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 14:30:27 -0400
Date: Tue, 23 Apr 2013 19:30:25 +0100
From: Mark Brown <broonie@kernel.org>
To: Wenyou Yang <wenyou.yang@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org, grant.likely@secretlab.ca,
        richard.genoud@gmail.com, plagnioj@jcrosoft.com,
        nicolas.ferre@atmel.com, JM.Lin@atmel.com,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 1/8] spi/spi-atmel: add physical base address
Message-ID: <20130423183025.GV5019@opensource.wolfsonmicro.com>
References: <1364968581-23700-1-git-send-email-wenyou.yang@atmel.com>
 <1364968662-23763-1-git-send-email-wenyou.yang@atmel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+VeMz1SRxFChf6vr"
Content-Disposition: inline
In-Reply-To: <1364968662-23763-1-git-send-email-wenyou.yang@atmel.com>
X-Cookie: Caution: Keep out of reach of children.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+VeMz1SRxFChf6vr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 03, 2013 at 01:57:42PM +0800, Wenyou Yang wrote:
> From: Nicolas Ferre <nicolas.ferre@atmel.com>
>=20
> Needed for future use with dmaengine enabled driver.

Applied, thanks.

--+VeMz1SRxFChf6vr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRdtMqAAoJELSic+t+oim9NwIQAJn6agyyqvkiND0/Ra2YIrY+
SRDF7VLU1ULCqERrM56YtjVdZCp/42tsxVStCmnjnAQEI1CffMotYqxj2Sk88oYK
jkITWmF5ZexIAYxRXFUIsAobf0GtX153nGI+QJpWKkOYa/w8L+JLhdKI9aHgPa5Z
RLQh5HQPy5CL5e+IxKVtqJ2G46sFaS/8eLy//EC4nMZ1D/PCt/N3h5H/ZlXtyOGQ
oExx8mt0fhY26JVwvTZwC9Yd3KIb5+Vq52dAN5eUwDgscrOk6Gg1rj6bTR1a30KI
BcSWfWKIFtWzbKsJvQidjkEiD9IBjXzFKlr7BJdfZPnBn1Q+VJ3NmO5bP6mk2OWo
O+8eLyHZVas2VKWmfCV5nVSuCrSHLPkFdOMqfC6cvn6KZsnk02kVn44MKtGM3QkH
o80k/68Ll/GBSKSrp4g7FsKiNTqTheVqJ1+A+Xw0vydrF8RT5ZYB6T1bMi4LKrLT
5Xx2IS4D0wBACsXyxugrAiFaj7yqHq3PQFPKWB4v8IjHm0p/PE+6xs2SNHcS8kn9
4sToMZC+YGPi+MJRHfWOR014tmGKpONnoTExxrNSpYzzJriKb0Jq5EntKo4mu62S
KabIiP+kQoW/ZibK/EULMNQM/dDVlEVVTE1SLThGJysy2s5mQGiPstM14oU2v9rx
1Oo98Uorb0OloDQJXrLg
=ps/5
-----END PGP SIGNATURE-----

--+VeMz1SRxFChf6vr--
