Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185AbbANPNQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 10:13:16 -0500
Received: from mail-la0-f45.google.com ([209.85.215.45]:46432 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753821AbbANPNN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 10:13:13 -0500
MIME-Version: 1.0
In-Reply-To: <CA+8Hj80oLByoaEWTQw_jchxfha1Gm=HhZp8pgTdeOb06fu=uQQ@mail.gmail.com>
References: <1420673754-6645-1-git-send-email-festevam@gmail.com>
	<CA+8Hj80oLByoaEWTQw_jchxfha1Gm=HhZp8pgTdeOb06fu=uQQ@mail.gmail.com>
Date: Wed, 14 Jan 2015 13:13:11 -0200
Message-ID: <CAOMZO5DEsQjhTcikozSS4J6=14AK6c0vmA-wbtp5ANJFU4zgSA@mail.gmail.com>
Subject: Re: [PATCH] ARM: imx_v6_v7_defconfig: Select CONFIG_FB_MXS
From: Fabio Estevam <festevam@gmail.com>
To: Liu Ying <liu.y.victor@gmail.com>
Cc: Shawn Guo <shawn.guo@linaro.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Fabio Estevam <fabio.estevam@freescale.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 8, 2015 at 1:15 AM, Liu Ying <liu.y.victor@gmail.com> wrote:

> So, similarly, we'll probably have two LCDIF drivers and make the DRM
> one enabled by default - finally, CONFIG_FB_MXS is disabled.

Yes, agree. Most likely it will take some time to get your new DRM
version reviewed/applied, so we could at least have some working
framebuffer on mx6sl and mx6sx in 3.20 by default with my patch.
