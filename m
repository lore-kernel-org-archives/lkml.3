Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754446Ab3BDRba (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 12:31:30 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:14516 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753176Ab3BDRb2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 12:31:28 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Mon, 04 Feb 2013 09:31:12 -0800
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Sami Liedes <sliedes@nvidia.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Mon, 4 Feb 2013 18:31:08 +0100
Subject: Re: [PATCH 1/2] ARM: tegra: Fix build error for gic update
Thread-Topic: [PATCH 1/2] ARM: tegra: Fix build error for gic update
Thread-Index: Ac4C/WuGgTbsYU+hRwSzY6CeH/JByQ==
Message-ID: <20130204.193108.1174796447728622419.hdoyu@nvidia.com>
References: <1359976100-28871-1-git-send-email-hdoyu@nvidia.com><510FE95B.20207@wwwdotorg.org>
In-Reply-To: <510FE95B.20207@wwwdotorg.org>
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

Stephen Warren <swarren@wwwdotorg.org> wrote @ Mon, 4 Feb 2013 18:01:15 +0100:

> On 02/04/2013 04:08 AM, Hiroshi Doyu wrote:
> > Fix build error in board-dt-tegra114.c(next-20130204)
> 
> Hiroshi, which tree should this patch be applied to? I assume it needs
> to go through arm-soc since that's where the Tegra and GIC patches meet?

"arm-soc" would be the place. Can you take care of this?
