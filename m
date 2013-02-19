Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757966Ab3BSDGO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 22:06:14 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:36395 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756279Ab3BSDGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 22:06:13 -0500
MIME-Version: 1.0
X-Originating-IP: [114.39.108.165]
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998F792729E9@DQHE02.ent.ti.com>
References: <A874F61F95741C4A9BA573A70FE3998F792729E9@DQHE02.ent.ti.com>
Date: Tue, 19 Feb 2013 11:06:12 +0800
Message-ID: <CAFRkauBB_BabSkP2Nz4sdDW78Tr7QYOC9Jdb+bXCWvsxtaDRrA@mail.gmail.com>
Subject: Re: [PATCH v3 0/4] regulator: core: support shared enable GPIO
From: Axel Lin <axel.lin@ingics.com>
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/2/18 Kim, Milo <Milo.Kim@ti.com>:
> A Regulator can be enabled by external GPIO pin which is configurable in the
> regulator_config.
> At this moment, the GPIO can be owned by only one regulator device.
> In some devices like LP8788 LDOs, multiple regulators are enabled by shared
> one GPIO pin.
> This patch-set enables shared enable GPIO concept and fix LP8788 LDO driver
> as well.

This patch serial looks good to me.
You can add:
Reviewed-by: Axel Lin <axel.lin@ingics.com>
