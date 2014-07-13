Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752646AbaGMDqK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 23:46:10 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:46534 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359AbaGMDp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 23:45:59 -0400
X-Auth-Info: s0EAKyoX1CsnD9HDRNLlDWunDWSBPwS5lepxvxAAmNc=
From: Marek Vasut <marex@denx.de>
To: Chen Gang <gang.chen.5i5j@gmail.com>
Subject: Re: [PATCH] drivers: Let several drivers depends on HAS_IOMEM for 'devm_ioremap_resource'
Date: Sun, 13 Jul 2014 05:45:22 +0200
User-Agent: KMail/1.13.7 (Linux/3.13-trunk-amd64; KDE/4.13.1; x86_64; ; )
Cc: gregkh@linuxfoundation.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dmitry.torokhov@gmail.com, thierry.reding@gmail.com, jic23@kernel.org,
        wim@iguana.be, benh@kernel.crashing.org, kys@microsoft.com,
        schwidefsky@de.ibm.com, teg@jklm.no, Mischa.Jonker@synopsys.com,
        msalter@redhat.com, lars@metafoo.de, richard@nod.at, knaack.h@gmx.de,
        rdunlap@infradead.org, linux-input@vger.kernel.org,
        linux-pwm@vger.kernel.org, linux-iio@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-watchdog@vger.kernel.org,
        Liqin Chen <liqin.linux@gmail.com>, Lennox Wu <lennox.wu@gmail.com>
References: <53C1F7DE.3060102@gmail.com>
In-Reply-To: <53C1F7DE.3060102@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201407130545.23004.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, July 13, 2014 at 05:07:10 AM, Chen Gang wrote:
> Several drivers need 'devm_ioremap_resource' which need HAS_IOMEM enabled.
> So let them depend on HAS_IOMEM.
> 
> The related error (with allmodconfig under score):
> 
>     MODPOST 1365 modules
>   ERROR: "devm_ioremap_resource" [drivers/watchdog/tegra_wdt.ko] undefined!
>   ERROR: "devm_ioremap_resource" [drivers/watchdog/of_xilinx_wdt.ko]
> undefined! ERROR: "devm_ioremap_resource"
> [drivers/staging/iio/adc/mxs-lradc.ko] undefined! ERROR:
> "devm_ioremap_resource" [drivers/pwm/pwm-clps711x.ko] undefined! ERROR:
> "devm_ioremap_resource" [drivers/input/serio/olpc_apsp.ko] undefined!
> ERROR: "devm_ioremap_resource" [drivers/input/serio/arc_ps2.ko] undefined!

This stuff should go through different trees, so I'd suggest to split this into 
multiple patches. Thanks for catching this stuff !

Best regards,
Marek Vasut
