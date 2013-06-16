Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859Ab3FPEXD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 00:23:03 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:62558 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909Ab3FPEXA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 00:23:00 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Paul Walmsley <pwalmsley@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <alpine.DEB.2.02.1306110944130.22645@utopia.booyaka.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Aleksandr Frid <afrid@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
References: <20130607121505.21868.72360.stgit@dusk.lan>
 <20130607121901.21868.65416.stgit@dusk.lan> <51B21105.1080301@wwwdotorg.org>
 <alpine.DEB.2.02.1306071703050.7753@utopia.booyaka.com>
 <51B6D239.5030905@nvidia.com>
 <alpine.DEB.2.02.1306110944130.22645@utopia.booyaka.com>
Message-ID: <20130616042256.7541.7096@quantum>
User-Agent: alot/0.3.4
Subject: Re: [PATCH 3/3] clk: tegra: T114: add DFLL DVCO reset control
Date: Sat, 15 Jun 2013 21:22:56 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Paul Walmsley (2013-06-11 02:47:13)
> On Tue, 11 Jun 2013, Prashant Gaikwad wrote:
> 
> > Why not implement these APIs in DFLL clock driver itself and pass RST address
> > register to driver?
> 
> The DFLL DVCO reset registers are CAR registers, not DFLL registers.  
> Functions that operate on registers in one IP block shouldn't be located 
> in another IP block's driver.

Paul & Co.,

These patches appear fine to me but I did not see any Acks, nor could I
tell if a v2 was necessary based on the comments. Will there be another
version? If not an Acked-by or Reviewed-by would be cool.

Regards,
Mike

> 
> 
> - Paul
