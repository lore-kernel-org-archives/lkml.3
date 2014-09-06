Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751662AbaIFOjB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2014 10:39:01 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:53587 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347AbaIFOi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2014 10:38:59 -0400
Date: Sat, 6 Sep 2014 15:38:28 +0100
From: Mark Brown <broonie@kernel.org>
To: Gyungoh Yoo <gyungoh@gmail.com>
Cc: lgirdwood@gmail.com, grant.likely@linaro.org, robh+dt@kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Gyungoh Yoo <jack.yoo@skyworksinc.com>
Message-ID: <20140906143828.GJ2601@sirena.org.uk>
References: <20140813190423.GI17528@sirena.org.uk>
 <1409539218-5571-1-git-send-email-jack.yoo@skyworksinc.com>
 <1409539218-5571-3-git-send-email-jack.yoo@skyworksinc.com>
 <20140901103158.GO29327@sirena.org.uk>
 <20140905015507.GA2636@jack-ThinkPad-T520>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ibvzjYYg+QDzMCy1"
Content-Disposition: inline
In-Reply-To: <20140905015507.GA2636@jack-ThinkPad-T520>
X-Cookie: Exercise caution in your daily affairs.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 92.40.248.127
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2.2 2/2] dt-bindings: Adding compatible attribute for
 SKY81452 regulator
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ibvzjYYg+QDzMCy1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Sep 05, 2014 at 10:55:07AM +0900, Gyungoh Yoo wrote:
> On Mon, Sep 01, 2014 at 11:31:58AM +0100, Mark Brown wrote:

> > Why is this a good idea - can this driver be used for anything other
> > than a sky81452?

> Yes. There is a possibility that this driver will be used by similar
> device with SKY81452.

OK, so tha was slightly the wrong question.  What added information is
forcing the user to create a subnode and specify a compatible string
providing?  This driver is specifying a block of multiple regulators
with absolute register addresses hard coded into it, there's no real
ability to use the driver in a different configuration here.  As soon as
we see the parent device we already know everything there is to know
about the IP block, having a separate compatible string just forces the
user to do more typing for no gain.

--ibvzjYYg+QDzMCy1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUCxxgAAoJECTWi3JdVIfQcBYH/R2CS4T/GKxj2OQMNW2zJrC8
FdTwq6lavlnYlxzmwXiOF7+grWbxXil5oLxw3N/qRPN2c5Tu2XaNz2BG2MK6gIgY
jgBIvY7tOKxnVohjcf2GWn60EyCZDBws76Exs3MJlE1qAPZjIeTt+eh42IGHCdo7
/JnBWobjro77Q8zJpHkEj31kjHrSb97POZoqn9gMOhpmWVdfJr/qbb6GKiu5rwJj
Kg7eNszlJx/739Rs732ZgEzdiIWXQkLT8d22Q6hW4Dz9aUKnJxohhpcFaqsM/vn5
Hfd+LKavPdodU8l0Rv4N7XEXVj0iMMWK0SB/WwV9aY2XM0bMai2W/8ULfdWiZCA=
=ncGW
-----END PGP SIGNATURE-----

--ibvzjYYg+QDzMCy1--
