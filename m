Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756102Ab3JRPOk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 11:14:40 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:47600 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755137Ab3JRPOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 11:14:38 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1310181632160.9158@axis700.grange>
References: <Pine.LNX.4.64.1310181632160.9158@axis700.grange>
Date: Fri, 18 Oct 2013 08:14:36 -0700
Message-ID: <CAGa+x86+qfWBou2jkEjz10ix95m89cxnyyFOPwryF27YezeoPw@mail.gmail.com>
Subject: Re: [BUILD BROKEN] Current Linus' master and -next don't build for imx_v6_v7_defconfig
From: Kevin Hilman <khilman@linaro.org>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 18, 2013 at 7:59 AM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:

> On current Linus' tree as of 04919af as well as -next since 16.10, IIRC,
> compilation is broken for i.MX3*, including the default
> imx_v6_v7_defconfig. The toolchain used is
>
> arm-none-linux-gnueabi-gcc (Sourcery CodeBench Lite 2012.09-64) 4.7.2

Just for another data point, I'm not seeing this in my builds
(arm-linux-gnueabi-gcc (Ubuntu/Linaro 4.7.2-1ubuntu1) 4.7.2) and we're
not seeing this in Olof's autobuilds either for latest mainline[1] or
latest next-thierry[2].  I belive Olof is using vanilla gcc 4.8.1.

Kevin

[1] http://lists.linaro.org/pipermail/kernel-build-reports/2013-October/000721.html
[2] http://lists.linaro.org/pipermail/kernel-build-reports/2013-October/000718.html
