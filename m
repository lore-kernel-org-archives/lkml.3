Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755367Ab3BDSfq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 13:35:46 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49625 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753975Ab3BDSfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 13:35:44 -0500
Date: Mon, 4 Feb 2013 18:35:42 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Hebbar Gururaja <gururaja.hebbar@ti.com>
Cc: alsa-devel@alsa-project.org,
        davinci-linux-open-source@linux.davincidsp.com,
        linux-arm-kernel@lists.infradead.org, tony@atomide.com,
        lgirdwood@gmail.com, perex@perex.cz, nsekhar@ti.com,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, rob@landley.net, grant.likely@secretlab.ca
Subject: Re: [PATCH v4 1/3] ASoC: tlv320aic3x: Convert mic bias to a supply
 widget
Message-ID: <20130204183542.GS4720@opensource.wolfsonmicro.com>
References: <1359636786-7056-1-git-send-email-gururaja.hebbar@ti.com>
 <1359636786-7056-2-git-send-email-gururaja.hebbar@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QHhm1I6mwQR20oIa"
Content-Disposition: inline
In-Reply-To: <1359636786-7056-2-git-send-email-gururaja.hebbar@ti.com>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--QHhm1I6mwQR20oIa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 31, 2013 at 06:23:04PM +0530, Hebbar Gururaja wrote:
> Convert MicBias widgets to supply widget.
>=20
> On tlv320aic3x, Mic bias power on/off shares the same register bits
> with output mic bias voltage.  So, when power on mic bias, we need
> reclaim it to voltage value.

Applied, thanks.

--QHhm1I6mwQR20oIa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRD/92AAoJELSic+t+oim918AP/3bN7+tsV2XR+Vsun5TsEEVO
3TJNYN4+rp6GmK+6zrvRaeRG/DueKGcLyPKx5N/SdWtncb1Cb708/lyYobz6RjmU
APSI0h4v7xCJXYrSACzM5g06EkAgpnlRD/BoS8um5jc25BDlfmtwLKO1ztE03ml2
vcTIEqfw9GLnYIse6P+3aiHeKYujQxZ9OY05MFAU1546/wzkCBxWdcePC9aGNFt/
fyxGMF1n3T5GlB9K45Ns42TFUKO/nTC0NbIV4gpEiMzXSgaz7/JQCXB//MJ+e9QM
NyiWhJEUGlh163S9de24WjR1XZfZ4qjxnocifnqssykQ6kmN0utUe5QAZzi04Ee4
tOYOLCJAZaz8/a7WlO4F9vIFOuWE5vHl4nytDq2ah7bL03ZwyIT74H/N+YaEBB1f
Uf6dwQRUCLgSyV+qWDdquatuCSME9JN8FH9JNE4+m5k+7T0yaIaCVjujqg34JZvJ
C0YFVxWYrDaJ+xPzCfTfq869+Xg8mCPypjeMUNvdbawUA0lxLWFETBuHgVm48txo
OEo3pmSJjMSprcwIyZPs4KgupjQGAbK5hFOVtxTtbOn847nga3FbbncHaZU36x6N
5xHKCYORQ3k4izByWTeMlJfV2C/YI1/ileBegt7M0+lPYZx9bBE1WTwOrmsBL9yi
H6JUyE1nwofq0of77aVq
=Ko0U
-----END PGP SIGNATURE-----

--QHhm1I6mwQR20oIa--
