Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753008Ab3AWGFM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 01:05:12 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:4282 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647Ab3AWGFJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 01:05:09 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 22 Jan 2013 22:04:48 -0800
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>
CC: "santosh.shilimkar@ti.com" <santosh.shilimkar@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "arnd@arndb.de" <arnd@arndb.de>, "olof@lixom.net" <olof@lixom.net>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Date: Wed, 23 Jan 2013 07:04:57 +0100
Subject: Re: [v3 2/2] ARM: tegra: Skip scu_enable(scu_base) if not Cortex A9
Thread-Topic: [v3 2/2] ARM: tegra: Skip scu_enable(scu_base) if not Cortex A9
Thread-Index: Ac35L5Kuq4lub03sTiueirlgJRy4Sg==
Message-ID: <20130123.080457.171573168772211248.hdoyu@nvidia.com>
References: <1358833924-24535-2-git-send-email-hdoyu@nvidia.com><50FE2CA8.20100@ti.com><50FEC503.2080602@wwwdotorg.org>
In-Reply-To: <50FEC503.2080602@wwwdotorg.org>
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

Stephen Warren <swarren@wwwdotorg.org> wrote @ Tue, 22 Jan 2013 17:57:39 +0100:

> Hiroshi, is this series the only dependency you need for your
> Tegra114

Basically yes.

> series? So, I could merge your Tegra114 series once this series is applied?

But now "CCF" seems to be in. Then, the HACK(*1) needs to be replaced
with "Tegra114 CCF". But "Tegra114 CCF" doesn't seem ready yet. I'll check
if this Tegra114 series would work without "Tegra114 CCF".

*1: http://patchwork.ozlabs.org/patch/212010/
