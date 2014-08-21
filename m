Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751528AbaHUOs3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 10:48:29 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:53154 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016AbaHUOs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 10:48:27 -0400
Date: Thu, 21 Aug 2014 09:47:43 -0500
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
Message-ID: <20140821144743.GG24407@sirena.org.uk>
References: <1408628104-16314-1-git-send-email-zyw@rock-chips.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+Pu8h6CsJtbukPM9"
Content-Disposition: inline
In-Reply-To: <1408628104-16314-1-git-send-email-zyw@rock-chips.com>
X-Cookie: If you can read this, you're too close.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 208.59.64.2
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3 4/5] Regulator: RK808: Add regulator driver for RK808
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+Pu8h6CsJtbukPM9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Aug 21, 2014 at 09:35:04PM +0800, Chris Zhong wrote:
> The regulator module consists of 4 DCDCs, 8 LDOs and 2 switches.
> The output voltages are configurable and are meant to supply power
> to the main processor and other components

I've already applied this, please send an incremental patch against the
current regulator tree with any fixes.

--+Pu8h6CsJtbukPM9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT9gaHAAoJELSic+t+oim9U3EP/ibS1dvB262ySQoGhfaSpUsN
CnaeYGmrMeLcZp/eQ2G6Pvz4IQQSHFd7QSWxGbp8y42OhuTjmm6sqJysKikfrp4i
o4trMw8iQyMW1tP85cb/LdtEVdX2JySpes2tWRUCeWJ49Pu2cIXGuLi9rdwAO5H7
FATnBkhY6aN9iOWeS4DUL/9eMxoII5BwcFYenFYhOdD+5GZvNTfS2BXGlBkMUpLG
Bzq/VXUusEPlb4OLo/R5lB9My8IuMx/lFkW4asNHwb/y1P9/rt0UYwirtsTjx8CY
VPE6GuBKAWUkhR8XUOr8AASPlysZVPizJcU5xmEqPUIs+Dw/M2v1Y4MOq4uq+7qP
OP1lody6+pd6+5Oi4nGVBnXk1oVaJupvuwZI5j+p4AaYR5m7sWpyxDq0g70u8N/f
uqt+I7+Jv5gx28RoKy9ADTwnLOs0j/+RhNVCss/Usx7Un/CpVIdaiEfadzjU/tK/
xJjqEx5NXBtZV9vnJHtvGKBakv20CWKlVZszl7pabUoFtIlzHPcek+004IF8huPM
sgAgeGnZxDRsYj7LK+F/OvZaBKslDyOzudYAWQu+dPA0O7W4BA2ud0n4kUM8K0Fc
ely9g1on+mbCjspcC+AQExe798dSJpFz/J74NyRBUnvvsOw+8I4J7ZI+tcPL/vuS
IAvskd/VJcSVhaeczcHm
=6ZWY
-----END PGP SIGNATURE-----

--+Pu8h6CsJtbukPM9--
