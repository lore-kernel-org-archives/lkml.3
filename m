Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758509AbaLJXyQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 18:54:16 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:54826 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758333AbaLJXyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 18:54:14 -0500
Date: Wed, 10 Dec 2014 23:53:47 +0000
From: Mark Brown <broonie@kernel.org>
To: Doug Anderson <dianders@chromium.org>
Cc: Ulf Hansson <ulf.hansson@linaro.org>, Heiko Stuebner <heiko@sntech.de>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Alexandru Stan <amstan@chromium.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Sonny Rao <sonnyrao@chromium.org>,
        Andrew Bresticker <abrestic@chromium.org>,
        linux-rockchip@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, lgirdwood@gmail.com,
        linux-kernel@vger.kernel.org
Message-ID: <20141210235347.GT11764@sirena.org.uk>
References: <1418245085-9754-1-git-send-email-dianders@chromium.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="m02j6EnzJ5dgRysN"
Content-Disposition: inline
In-Reply-To: <1418245085-9754-1-git-send-email-dianders@chromium.org>
X-Cookie: I don't get no respect.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/4] regulator: core: Support trying to get close to a
 certain voltage
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--m02j6EnzJ5dgRysN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 10, 2014 at 12:58:02PM -0800, Doug Anderson wrote:
> There are some cases where you'd like to set a voltage for a regulator
> and a range of voltages are OK, but you'd really like to get as close
> as you can to a specific voltage if at all possible.

This looks like regulator_set_voltage_tol(), why not use that?  The spec
probably even has a number for the tolerance, or you can make one up.

--m02j6EnzJ5dgRysN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUiN0KAAoJECTWi3JdVIfQ6kUH/RZuwsm3G6iSJLkEspFELg2o
91372XWoj39DNiKunui6Voo6x4YCMoU5LIhRD9eUV0fcG8l48adiUjgxaly6hTn1
uGPC84rqc2x2kua3UDnGGTP5VRIKbsf/bqz/+dLnlCQW5qSYGvp26Jn65YufWDlX
krefWXorgbfYvwywLTC/PYCbjHW+R7iBPu/01pNNkf4wJdiAsaIcxzWe8T95mNyr
jFNzsIoKMWhX0uiqt0OxvYFbijR1+r++1cFT2d+pTCn9Bt2wctKG+x+GPXR/sf+E
3Fs7KfTVc9+Wi6W3ljSM8gKgZF0ksMMft1ZvPnYP1mtp7CTtZ0LyMNRB4FjsBG0=
=3eTb
-----END PGP SIGNATURE-----

--m02j6EnzJ5dgRysN--
