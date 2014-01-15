Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751555AbaAOKzE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 05:55:04 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:54582 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705AbaAOKzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 05:55:00 -0500
Date: Wed, 15 Jan 2014 10:54:46 +0000
From: Mark Brown <broonie@kernel.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: Saravana Kannan <skannan@codeaurora.org>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Message-ID: <20140115105446.GF15567@sirena.org.uk>
References: <1387847559-18330-1-git-send-email-sboyd@codeaurora.org>
 <1387847559-18330-3-git-send-email-sboyd@codeaurora.org>
 <20140109015158.7168.60274@quantum>
 <52D4B502.3080409@codeaurora.org>
 <20140115093641.4167.83109@quantum>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DOr+hlVy7JMLa9bO"
Content-Disposition: inline
In-Reply-To: <20140115093641.4167.83109@quantum>
X-Cookie: Marriage is the sole cause of divorce.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v4 02/15] clk: Allow drivers to pass in a regmap
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DOr+hlVy7JMLa9bO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 15, 2014 at 01:36:41AM -0800, Mike Turquette wrote:

> Providing common functions for the basic case (e.g. read-modify-write on
> a register using a known mask) is reasonable. But that is exactly what
> the existing basic clock types do (sans regmap) and they have all become
> pretty ugly over time. And the clk-composite implementation just makes
> me a sad panda.

What we've tried to do with regulators is just have multiple helper
functions in the core rather than trying to merge their implementation,
the drivers pick the right one for their usage, and in cases where there
aren't many drivers doing the same thing we just have the driver either
copy the bits of the implementation they reuse or call the helper
function from within the implementation.

--DOr+hlVy7JMLa9bO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS1mjzAAoJELSic+t+oim9D3MQAJWxAv5ObrqZzQqnXqQpGffT
RzaazYXTS6sDurATNVUl1vkanQ/eRSco1ndZUXpIpm61/uE3HcwpNckPH7KuH9lT
u4PUqlfWUWwS8Ydx6nPN8EXAfzXf+qsTdAlwvAMwNFZSiznJ9YsEzdEVlLW4Yx2O
r7OGHKnI91XwNFDyN1j1ZHUt9VkEOuWM4NaZ2ttL/lpMBZr33fQ7F2XByki6SzhW
tymRAdHfIhuc/2k+4jvR+YU1rIjEpe3qJ9EDmxwK2CvG8RWY+/vaPDfYnv5wNbZU
ELs/9/ukcVJM2FzDzlg4XULDs4yW6LbbPtbPINpxxcB0kv3Z9q/u+PBeggRgiLCg
fwjnrCy2rsjQlQEtqBYSmamN9ePfErkPQoLHaY85SSyGRFdbWzDDZI//lI5ufH6M
v1LradqIeSvfmsBNXA6I37risIDQwyxBl9TxkV03vVRnWcziLO9U9AZJkavpEGtP
ZHpk6rVuJFFBN65HKCgjZQAEi9K1ZYOhAsTWqrJNNYTlitwlTq5I3NiuHjF0l6ZW
iUY6sRt8K0lhOlujzTDZcRLcP3LMIITrWbxMcH5BNZCD9kH5rCtDFTDXs7PEPVhs
0OIYYzuFZoyalmYfP7rENKfdyu/ZALisFecd4vQTNhQTjTKnCusIM9Z7jnQgi9oA
bT+3zehWWzyOZgAekXFL
=kj9T
-----END PGP SIGNATURE-----

--DOr+hlVy7JMLa9bO--
