Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756583AbaJHNbl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 09:31:41 -0400
Received: from know-smtprelay-omc-3.server.virginmedia.net ([80.0.253.67]:42747
	"EHLO know-smtprelay-omc-3.server.virginmedia.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756347AbaJHNbi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 09:31:38 -0400
X-Originating-IP: [81.99.114.138]
X-Spam: 0
X-Authority: v=2.1 cv=N7qnFgNB c=1 sm=1 tr=0 a=rTb9Q+mClrhkGV9Ah9iRIA==:117
 a=rTb9Q+mClrhkGV9Ah9iRIA==:17 a=N1CowNylAAAA:8 a=3FMK0p1cVuKbq0TN6BsA:9
 a=QEXdDO2ut3YA:10 a=ZbphizX4KjIA:10 a=tZi1akKXmSzKDDD5L3IA:9 a=C2F9r2UhgvoA:10
Message-ID: <1412775085.2797.10.camel@snewbury.org.uk>
Subject: Re: [PATCH v9 1/3] drm: rockchip: Add basic drm driver
From: Steven Newbury <steve@snewbury.org.uk>
To: Mark yao <mark.yao@rock-chips.com>
Cc: Andrzej Hajda <a.hajda@samsung.com>, heiko@sntech.de,
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
Date: Wed, 08 Oct 2014 14:31:25 +0100
In-Reply-To: <543490A8.7030807@rock-chips.com>
References: <1412081870-27535-1-git-send-email-mark.yao@rock-chips.com>
		 <1412082181-27703-1-git-send-email-mark.yao@rock-chips.com>
		 <542AB0B2.6000207@samsung.com> <54336474.1010503@rock-chips.com>
		 <54338484.5070809@samsung.com> <1412720776.2797.8.camel@snewbury.org.uk>
	 <543490A8.7030807@rock-chips.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-X3UhQ3efMecwITDeaM/h"
X-Mailer: Evolution 3.13.7 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-X3UhQ3efMecwITDeaM/h
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2014-10-08 at 09:17 +0800, Mark yao wrote:
> Hi Steven
>      I'm glad to see you to discuss about rk29xx.
>=20
> On 2014=E5=B9=B410=E6=9C=8808=E6=97=A5 06:26, Steven Newbury wrote:
> > I've just been discussing how this relates to rk29xx on #etnaviv. =20
> > I
> > looked through the patch and it's good to see it's not limited to
> > supporting Mali GPUs.  I see no reason this wouldn't be compatible
> > with etna_viv for rk29xx (or future Rockchip designs with=20
> > alternative
> > GPUs) as long as the rest of the infrastructure to support rk29 is=20
> > in
> > place iommu (ARM SMMU?) driver, for example.
> Now the drm driver only test on rk3288, and future when we add
> compatible for rk29xx, we
> would consider to add a non-iommu path for it.
That's great! I'm working on trying to update the rk29 driver support.=20
 Getting it supported where possible with the new drivers would make=20
it much easier, hopefully such that simply creating a new dts file=20
would produce a working kernel for any useful hardware out there.

> > IMHO it's vital to keep a logical separation between the video=20
> > display
> > hardware and the graphics processor on SoCs.
> Sure, the graphics processor maybe change in different solutions,
> logical separation is that we
> try to keep.

--=-X3UhQ3efMecwITDeaM/h
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEABECAAYFAlQ1PLEACgkQGcb56gMuC63rJwCfRFIwyIj6FOSIqULpaJIrWWl9
MioAnj0lnUS5+25TZ24KHThJQOk68I8v
=FDMG
-----END PGP SIGNATURE-----

--=-X3UhQ3efMecwITDeaM/h--

