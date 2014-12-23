Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755400AbaLWIJ2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 03:09:28 -0500
Received: from mout.kundenserver.de ([212.227.126.187]:65274 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754813AbaLWIJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 03:09:26 -0500
Date: Tue, 23 Dec 2014 09:09:12 +0100 (CET)
From: Stefan Wahren <stefan.wahren@i2se.com>
Reply-To: Stefan Wahren <stefan.wahren@i2se.com>
To: Liu Ying <Ying.Liu@freescale.com>, dri-devel@lists.freedesktop.org
Cc: kernel@pengutronix.de, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, thierry.reding@gmail.com,
        shawn.guo@linaro.org, airlied@linux.ie, andyshrk@gmail.com,
        p.zabel@pengutronix.de, mturquette@linaro.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Message-ID: <789433791.920346.1419322152848.JavaMail.open-xchange@oxbaltgw08.schlund.de>
In-Reply-To: <1419306399-9387-3-git-send-email-Ying.Liu@freescale.com>
References: <1419306399-9387-1-git-send-email-Ying.Liu@freescale.com> <1419306399-9387-3-git-send-email-Ying.Liu@freescale.com>
Subject: Re: [PATCH RFC v3 02/18] of: Add vendor prefix for Himax
 Technologies Inc.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Priority: 3
Importance: Medium
X-Mailer: Open-Xchange Mailer v7.6.0-Rev33
X-Originating-Client: com.openexchange.ox.gui.dhtml
X-Provags-ID: V03:K0:Uks7TAgurBoJRBieXlK8rj70ANTiow1AAWV0RTQ+3w/VSU9uA6X
 ynGYFg5S/sKEWxGWmX8m9pHUjjFu9Wx0rk1tmV8M6PUm9XHJEdNH9BMczfmFYgZ1vu0t6jr
 JsPw0NXpEdwmRc0xigbtTZ4raNePToLcC0HeF2Iff9dqH0rkaE7jtS5uY5Z/UijloBYMkKR
 qgzYYShufh3nFyDtAI2uQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Liu,

> Liu Ying <Ying.Liu@freescale.com> hat am 23. Dezember 2014 um 04:46
> geschrieben:
>
>
> Signed-off-by: Liu Ying <Ying.Liu@freescale.com>
> ---
> v2->v3:
> * None.
>
> v1->v2:
> * None.
>
> Documentation/devicetree/bindings/vendor-prefixes.txt | 1 +
> 1 file changed, 1 insertion(+)
>
> diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt
> b/Documentation/devicetree/bindings/vendor-prefixes.txt
> index 78efebb..3cee528 100644
> --- a/Documentation/devicetree/bindings/vendor-prefixes.txt
> +++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
> @@ -69,6 +69,7 @@ hannstar HannStar Display Corporation
> haoyu Haoyu Microelectronic Co. Ltd.
> hisilicon Hisilicon Limited.
> hit Hitachi Ltd.
> +himax Himax Technologies, Inc.

please fix the ordering. himax comes before hisilicon.

Thanks

Stefan

> honeywell Honeywell
> hp Hewlett Packard
> i2se I2SE GmbH
> --
> 2.1.0
>
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
