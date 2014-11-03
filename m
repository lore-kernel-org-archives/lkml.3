Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751698AbaKCMtZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 07:49:25 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:35363 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379AbaKCMtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 07:49:22 -0500
Date: Mon, 3 Nov 2014 12:47:40 +0000
From: Mark Brown <broonie@kernel.org>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Doug Anderson <dianders@chromium.org>, Heiko Stuebner <heiko@sntech.de>,
        Chris Zhong <zyw@rock-chips.com>,
        Andrew Bresticker <abrestic@chromium.org>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, lgirdwood@gmail.com,
        linux-kernel@vger.kernel.org
Message-ID: <20141103124740.GM3815@sirena.org.uk>
References: <1414813978-32233-1-git-send-email-dianders@chromium.org>
 <1414813978-32233-2-git-send-email-dianders@chromium.org>
 <54549EA6.5060007@collabora.co.uk>
 <20141103122948.GI3815@sirena.org.uk>
 <545778DB.3030803@collabora.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wAI/bQb0EMvlZCHl"
Content-Disposition: inline
In-Reply-To: <545778DB.3030803@collabora.co.uk>
X-Cookie: Some optional equipment shown.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/2] regulator: of: Add support for parsing microvolts
 for suspend state
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wAI/bQb0EMvlZCHl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 03, 2014 at 01:45:15PM +0100, Javier Martinez Canillas wrote:

> Yes, I usually add my {Review,Acked,Tested}-by tags at the end of the
> commit message and remove the complete patch but since it was a 4-lines
> patch I didn't think it was that bad.

It's the patch, the diffstat, the signoff, the commit message...

--wAI/bQb0EMvlZCHl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUV3lrAAoJECTWi3JdVIfQnUYH/0fLTbH8SpIRgq5bFewnlUxu
+IFJePvuFLm6QCqwLuCjz8KVSrXBH1CLG6+VfT56QWHbWAB8EXKI1oIHDDXIyAMi
jo6mH45ax1+8dIAm8QZNi+ucENZf51uQZGGufCF2feOKK8K01sfhjjZaJEatXTGp
3NaEac3mxILQFLqUusghrpfcyVd6+lUYz2FIe6ILNVcS2uwFE4U83zqaIMztTADh
EEoFrIex+0I8vtYeKhX2SgirVU+On5Flyj0Zj6ccjg0YDckSIcK/5g7n8g/8yJif
/I5XgRcC9fhXo4tVI/epaPr4ypy8g3fZ3x9NuLb5KW083Ztxjj0J1NF+KamTpB0=
=DZtj
-----END PGP SIGNATURE-----

--wAI/bQb0EMvlZCHl--
