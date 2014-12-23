Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755658AbaLWIdi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 03:33:38 -0500
Received: from mout.kundenserver.de ([212.227.126.130]:49507 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754801AbaLWIdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 03:33:37 -0500
Date: Tue, 23 Dec 2014 09:33:16 +0100 (CET)
From: Stefan Wahren <stefan.wahren@i2se.com>
Reply-To: Stefan Wahren <stefan.wahren@i2se.com>
To: Liu Ying <Ying.Liu@freescale.com>, dri-devel@lists.freedesktop.org
Cc: kernel@pengutronix.de, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, thierry.reding@gmail.com,
        shawn.guo@linaro.org, airlied@linux.ie, andyshrk@gmail.com,
        p.zabel@pengutronix.de, mturquette@linaro.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Message-ID: <1770602566.921194.1419323596151.JavaMail.open-xchange@oxbaltgw08.schlund.de>
In-Reply-To: <1419306399-9387-12-git-send-email-Ying.Liu@freescale.com>
References: <1419306399-9387-1-git-send-email-Ying.Liu@freescale.com> <1419306399-9387-12-git-send-email-Ying.Liu@freescale.com>
Subject: Re: [PATCH RFC v3 11/18] drm/bridge: Add Synopsys DesignWare MIPI
 DSI host controller driver
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Priority: 3
Importance: Medium
X-Mailer: Open-Xchange Mailer v7.6.0-Rev33
X-Originating-Client: com.openexchange.ox.gui.dhtml
X-Provags-ID: V03:K0:joWPYKydeTPYD1WKZXFnfV+Dz+ibR6H7YxSxi7ekDnOrbl28C2/
 U0THRZP+QSiHr2okbH3lyAegjf8YD7lt1CLvrOROFuO+/u8SvFlcvXv1bhRiOFECkMQL6LX
 SQ3pVYWi06r5uIDeWj9187pWrkQgodFNOL9YNfqaCQTJya/Z/F3bMOURLlEgU7yVZ9C6phP
 CC6Z9e0CxGr8/YJvnHj9A==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Liu,

> Liu Ying <Ying.Liu@freescale.com> hat am 23. Dezember 2014 um 04:46
> geschrieben:
>
>
> This patch adds Synopsys DesignWare MIPI DSI host controller driver support.
> Currently, the driver supports the burst with sync pulses mode only.
>
> Signed-off-by: Liu Ying <Ying.Liu@freescale.com>
> ---
> v2->v3:
> * Newly introduced in v3 to address Andy Yan's comment. This is based on
> the i.MX MIPI DSI driver in v2. To make the Synopsys DesignWare MIPI DSI
> host controller driver less platform-dependant, this patch places it at
> the drm/bridge directory as a DRM bridge driver.
>
> .../devicetree/bindings/drm/bridge/dw_mipi_dsi.txt | 72 ++

please take care of [1] and send the Documentation part as a separate patch.
This should also apply to all the other patches from your series.

Thanks

Stefan

[1] -
http://lxr.free-electrons.com/source/Documentation/devicetree/bindings/submitting-patches.txt
