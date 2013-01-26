Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753301Ab3AZKDy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 05:03:54 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:60923 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753117Ab3AZKDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 05:03:52 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH] regmap: debugfs: Work around GCC flow analysis false positives
Date: Sat, 26 Jan 2013 10:03:45 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-1-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org,
        Vincent =?utf-8?q?Stehl=C3=A9?= <v-stehle@ti.com>
References: <1359194478-31666-1-git-send-email-broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1359194478-31666-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201301261003.45874.arnd@arndb.de>
X-Provags-ID: V02:K0:Ln8i2Mi6B0jimRhXROxnLXNtBLubTa0ULib6yn6rHzA
 bhcieOG3nZ/56FpPy9gR5SiXyyG2dxhraq3ejdwTZ5b2wB+221
 7lSneR83+DvF6UGo73whS2MgEduwqtTvPbhFw9fZQ42afAMzCz
 GszQf3jPePFoF3EyEpazNR/9Gn6ePTc1wjZXgkCwy5cQc+FqFU
 GvXUCrbrkK46uU/Vq8R0j7yzmZtRB8Qd3GeAzUcnnGhuIk6RG+
 3EgrSBzjTAPXz+obAg3hQpWh6tsbtT6l3NBmwjLlW2ieTtOUUu
 2mkcxB1huSJVCGK2lZHtcwmxEEgWqz7p/ENQCiSGgyVpQaqAHL
 GVSKWkbDeL/FRnoOi/hA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 26 January 2013, Mark Brown wrote:
> Reported-by: Vincent Stehlé <v-stehle@ti.com>
> Reported-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Thanks for fixing this properly.

Acked-by: Arnd Bergmann <arnd@arndb.de>
