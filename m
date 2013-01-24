Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750945Ab3AXGmb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 01:42:31 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:3822 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056Ab3AXGmX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 01:42:23 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Wed, 23 Jan 2013 22:42:10 -0800
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>
CC: "santosh.shilimkar@ti.com" <santosh.shilimkar@ti.com>,
        "olof@lixom.net" <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Date: Thu, 24 Jan 2013 07:42:06 +0100
Subject: Re: [v3 2/2] ARM: tegra: Skip scu_enable(scu_base) if not Cortex A9
Thread-Topic: [v3 2/2] ARM: tegra: Skip scu_enable(scu_base) if not Cortex A9
Thread-Index: Ac35/e3Crw6HX5chSi+PW1IWk3yy9A==
Message-ID: <20130124.084206.122831115046505200.hdoyu@nvidia.com>
References: <CAOesGMgtaCkiv285TU_vbAokN5M2MrANQ9piDcyXu5YMmbQq3A@mail.gmail.com><50FFA620.50008@ti.com><5100C0F7.9080101@wwwdotorg.org>
In-Reply-To: <5100C0F7.9080101@wwwdotorg.org>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-nvconfidentiality: public
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Warren <swarren@wwwdotorg.org> wrote @ Thu, 24 Jan 2013 06:04:55 +0100:

> Branch scu-base-rework contains just the SCU base address patches. After
> the few things listed below, I'll rename this branch and send a pull
> request to arm-soc.
> 
....
> 2) Lorenzo's last comment on "ARM: tegra: Use DT /cpu node to detect
> number of CPU core" was:
> 
> Please add missing punctuation, reword the commit log to make it clearer.
> 
> ... so that patch needs a reworded commit log.

I fixed. I'll send this[1] as a part of the "Tegra114 series(v4)" today.

[1] ARM: tegra: Use DT /cpu node to detect number of CPU core
