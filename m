Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754466Ab3FKJrR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 05:47:17 -0400
Received: from utopia.booyaka.com ([74.50.51.50]:33304 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754401Ab3FKJrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 05:47:15 -0400
Date: Tue, 11 Jun 2013 09:47:13 +0000 (UTC)
From: Paul Walmsley <pwalmsley@nvidia.com>
To: Prashant Gaikwad <pgaikwad@nvidia.com>
cc: Stephen Warren <swarren@wwwdotorg.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "mturquette@linaro.org" <mturquette@linaro.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Aleksandr Frid <afrid@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 3/3] clk: tegra: T114: add DFLL DVCO reset control
In-Reply-To: <51B6D239.5030905@nvidia.com>
Message-ID: <alpine.DEB.2.02.1306110944130.22645@utopia.booyaka.com>
References: <20130607121505.21868.72360.stgit@dusk.lan> <20130607121901.21868.65416.stgit@dusk.lan> <51B21105.1080301@wwwdotorg.org> <alpine.DEB.2.02.1306071703050.7753@utopia.booyaka.com> <51B6D239.5030905@nvidia.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Jun 2013, Prashant Gaikwad wrote:

> Why not implement these APIs in DFLL clock driver itself and pass RST address
> register to driver?

The DFLL DVCO reset registers are CAR registers, not DFLL registers.  
Functions that operate on registers in one IP block shouldn't be located 
in another IP block's driver.


- Paul
