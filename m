Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755530AbaJGWfE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 18:35:04 -0400
Received: from know-smtprelay-omc-2.server.virginmedia.net ([80.0.253.66]:47145
	"EHLO know-smtprelay-omc-2.server.virginmedia.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755517AbaJGWe6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 18:34:58 -0400
X-Originating-IP: [81.99.114.138]
X-Spam: 0
X-Authority: v=2.1 cv=AoZg3YNP c=1 sm=1 tr=0 a=rTb9Q+mClrhkGV9Ah9iRIA==:117
 a=rTb9Q+mClrhkGV9Ah9iRIA==:17 a=N1CowNylAAAA:8 a=sl_BgbeAKdICNFk6qqAA:9
 a=QEXdDO2ut3YA:10 a=tOduzXxj6vwy2j9bMnEA:9 a=m65m9HV2r7MA:10
Message-ID: <1412720776.2797.8.camel@snewbury.org.uk>
Subject: Re: [PATCH v9 1/3] drm: rockchip: Add basic drm driver
From: Steven Newbury <steve@snewbury.org.uk>
To: Andrzej Hajda <a.hajda@samsung.com>
Cc: Mark yao <mark.yao@rock-chips.com>, heiko@sntech.de,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        David Airlie <airlied@gmail.com>, Rob Clark <robdclark@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Rom Lemarchand <romlem@google.com>, linux-doc@vger.kernel.org,
        kever.yang@rock-chips.com, dri-devel@lists.freedesktop.org,
        dianders@chromium.org, xjq@rock-chips.com, zyw@rock-chips.com,
        cym@rock-chips.com, linux-rockchip@lists.infradead.org,
        kfx@rock-chips.com, wxt@rock-chips.com, huangtao@rock-chips.com,
        devicetree@vger.kernel.org, dbehr@chromium.org, yxj@rock-chips.com,
        olof@lixom.net, djkurtz@chromium.org, marcheu@chromium.org,
        xxm@rock-chips.com, xw@rock-chips.com, linux-api@vger.kernel.org,
        linux-kernel@vger.kernel.org, cf@rock-chips.com
Date: Tue, 07 Oct 2014 23:26:16 +0100
In-Reply-To: <54338484.5070809@samsung.com>
References: <1412081870-27535-1-git-send-email-mark.yao@rock-chips.com>
	 <1412082181-27703-1-git-send-email-mark.yao@rock-chips.com>
	 <542AB0B2.6000207@samsung.com> <54336474.1010503@rock-chips.com>
	 <54338484.5070809@samsung.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-3Ej4YuX3v57Rb2M1m87J"
X-Mailer: Evolution 3.13.7 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-3Ej4YuX3v57Rb2M1m87J
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I've just been discussing how this relates to rk29xx on #etnaviv.  I=20
looked through the patch and it's good to see it's not limited to=20
supporting Mali GPUs.  I see no reason this wouldn't be compatible=20
with etna_viv for rk29xx (or future Rockchip designs with alternative=20
GPUs) as long as the rest of the infrastructure to support rk29 is in=20
place iommu (ARM SMMU?) driver, for example.

IMHO it's vital to keep a logical separation between the video display=20
hardware and the graphics processor on SoCs.


--=-3Ej4YuX3v57Rb2M1m87J
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEABECAAYFAlQ0aIwACgkQGcb56gMuC61YdQCgroIqzaz6iZoEizQwqvTsmlZd
1SgAnjRCWI26AASReJl6LwPDw2BmKaIK
=WXIm
-----END PGP SIGNATURE-----

--=-3Ej4YuX3v57Rb2M1m87J--

