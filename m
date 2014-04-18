Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753585AbaDRRfN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 13:35:13 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:38138 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205AbaDRRfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 13:35:09 -0400
Date: Fri, 18 Apr 2014 18:34:37 +0100
From: Mark Brown <broonie@kernel.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: lgirdwood@gmail.com, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, rdunlap@infradead.org, sameo@linux.intel.com,
        lee.jones@linaro.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Message-ID: <20140418173437.GS12304@sirena.org.uk>
References: <1397638902-7576-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
 <1397638902-7576-2-git-send-email-ckeepax@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WyWfLelG/ECAAsip"
Content-Disposition: inline
In-Reply-To: <1397638902-7576-2-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Cookie: You will be successful in your work.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/6] mfd: arizona: Factor out read of device tree GPIOs
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WyWfLelG/ECAAsip
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 16, 2014 at 10:01:37AM +0100, Charles Keepax wrote:
> This patch factors out the reading of GPIOs for the Arizona devices
> into a helper function.

Applied, thanks.

--WyWfLelG/ECAAsip
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTUWIpAAoJELSic+t+oim9AKsP+wZWPxgZmUr7zyM6kzEOUgS3
FblhL53XRt8mydy23a6k6yYYtlEa7y+2DFXtFKYEb13LSMzFluqKcsm21SsbgzfQ
n/zIIbr7S2r4qzNfurC2yEmAfanekwPCc/SlLVBK0DZj93qYkqk+oWiRBsB0XFBM
2AYDs2B71QwQADdlaUTz/NbvXLAhhrSxs2IxxV6sqKNwyE/lydc4rKFXz1eNPb2U
RJcXLH4dqoS0mlY9sU66tBGUoaE1KI076hePolnDBoOf31d3/4B5BsoWi/06BYZg
hEr7yB5b2Q9R9POHU882czQM1gy5ECOMhYINnir02KY1cFxIO3TgAEgZBY08f7xs
Vy4h5jspdoiLloHBVBdM8cTgx0WbWwcSRFAX4yP74CnhiYECDQzXt/f4tCeibU/9
ig8BFJeuGFA2wdegUL24BTn/y2wlBqA814pCqU0jXpSgeasA9usxCCKSSME46oqY
5V0biKpKFEiRhxUG7m4JW//OrM7H8RBAgtB5WF4+rSFeAXLOczQZ3lscIljuNtB1
G3/rwVgQFxvdd0NqbuM8z6Wya/xacdQkm/Erv37ZPED9y2zkvMpoI3FI439aZMCX
spmwssZenef53Noz0QvRkbulXEWjitF9Lo9LufzhfR6vyow3l+YMMI1NL1kj2eFD
TmivSaruGvFk8/p6Wk9p
=lrpU
-----END PGP SIGNATURE-----

--WyWfLelG/ECAAsip--
