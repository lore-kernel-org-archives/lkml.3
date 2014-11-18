Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487AbaKRPiM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 10:38:12 -0500
Received: from gloria.sntech.de ([95.129.55.99]:40485 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755312AbaKRPiK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 10:38:10 -0500
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Julien CHAUVEAU <julien.chauveau@neo-technologies.fr>
Cc: Mike Turquette <mturquette@linaro.org>,
        "moderated list:ARM/Rockchip SoC..." 
	<linux-arm-kernel@lists.infradead.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        "open list:COMMON CLK FRAMEWORK" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] clk: rockchip: fix parent clock for rk3188 hclk_lcdc1
Date: Tue, 18 Nov 2014 16:41:48 +0100
Message-ID: <3112886.9YHa130KKH@diego>
User-Agent: KMail/4.14.1 (Linux/3.16-3-amd64; KDE/4.14.2; x86_64; ; )
In-Reply-To: <1416309043-29069-1-git-send-email-julien.chauveau@neo-technologies.fr>
References: <1416309043-29069-1-git-send-email-julien.chauveau@neo-technologies.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Julien,

Am Dienstag, 18. November 2014, 12:10:43 schrieb Julien CHAUVEAU:
> The parent clock for hclk_lcdc1 was set to aclk_cpu instead of hclk_cpu.
> 
> Signed-off-by: Julien CHAUVEAU <julien.chauveau@neo-technologies.fr>

thanks for catching this. I've applied it to my clk branch for 3.19


Heiko
