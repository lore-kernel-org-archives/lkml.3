Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932539AbaH0JCc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 05:02:32 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:35654 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524AbaH0JCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 05:02:30 -0400
Date: Wed, 27 Aug 2014 10:01:46 +0100
From: Mark Brown <broonie@kernel.org>
To: Chris Zhong <zyw@rock-chips.com>
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        sameo@linux.intel.com, lee.jones@linaro.org, lgirdwood@gmail.com,
        a.zummo@towertech.it, mturquette@linaro.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com, grant.likely@linaro.org, hl@rock-chips.com,
        huangtao@rock-chips.com, cf@rock-chips.com, zhangqing@rock-chips.com,
        xxx@rock-chips.com, dianders@chromium.org, heiko@sntech.de,
        olof@lixom.net, sonnyrao@chromium.org, dtor@chromium.org,
        javier.martinez@collabora.co.uk, kever.yang@rock-chips.com
Message-ID: <20140827090146.GU17528@sirena.org.uk>
References: <1409062737-12259-1-git-send-email-zyw@rock-chips.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="q7cvAXluP2XyzQqh"
Content-Disposition: inline
In-Reply-To: <1409062737-12259-1-git-send-email-zyw@rock-chips.com>
X-Cookie: 98% lean.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v6 5/5] regulator: RK808: remove redundant code
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--q7cvAXluP2XyzQqh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 26, 2014 at 10:18:57PM +0800, Chris Zhong wrote:
> remove the redundant code, since pdata has been removed from stuct rk808

I've applied this but if there's further changes needed please wait
until the MFD changes they depend on have been accepted before
resending.  This will be less work all round.

--q7cvAXluP2XyzQqh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT/Z52AAoJELSic+t+oim9A8gP/i//MAT/Sm3djBei7vBX27dJ
UZ65GhPPDSkDCyNDxjJ6FddpkB1hc8/qxSqOLspG+7C2Iawq46z45/rv4Zp2nqGW
4wd8WJ5pa55D6tJU/IV/j1rKnu7CECbuDU1fyoryXeY+VqVvnGUrRU7oVm3iLe9+
t1tWrLHPr6q7m/IUoQWIdPATxTBDB8KI8w/whwANfzEKF2Jiq22DoAgdxfLWtDdz
+fPm7+JXdzY8+6Tf9R2G/YMgojKi3lPkqxFfqBZn0KFSQChMuzF0gDWwhB2A1uhj
FUzIZdUSRnzGMvl4QXDNDWBkKUeKKafCizX0YRfklK+a0wbhzzJ40dEVpifEiOj7
dxXITUuoFteSFxyiaBsk+XUy5Ue0zSAY667vOh0H0osqm1BkJOCwj8vH9zhSVD/O
HY5FC3tbr6e+YdqPoMj1BT564DPWeaa+S01X3B2gjFHxk1Ti7oStqkURV+8zTHfY
xHdPe/Z6Df6oMk+hQnxvdOeYplAFxA66OcrQ4VIHiBjzbiTBLnXP6Lv7EdT/sE+s
sRGjzBwG+Eftt/fODVWDUhmXyMvgm9LRQTqszRFgnjLxsIn2Y2YQTY4/L39A7AJK
ua/FSLllSPG5DZvdt78KDTlARRVeB1gxYEDpEJSGpA/byh80UsAMrBi5LY00Ls+Z
ZoCOB+gSEzpRb44JhdZ6
=Yu4Y
-----END PGP SIGNATURE-----

--q7cvAXluP2XyzQqh--
