Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932358Ab3LDOkU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 09:40:20 -0500
Received: from mail-yh0-f52.google.com ([209.85.213.52]:52313 "EHLO
	mail-yh0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932262Ab3LDOkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 09:40:18 -0500
Date: Wed, 4 Dec 2013 14:40:10 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: Stefan Agner <stefan@agner.ch>, swarren@wwwdotorg.org,
        thierry.reding@gmail.com, dev@lynxeye.de, lgirdwood@gmail.com,
        kai.poggensee@avionic-design.de, sameo@linux.intel.com,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-tegra-owner@vger.kernel.org
Subject: Re: [PATCH v4 2/3] regulator: tps6586x: add and use correct voltage
 table
Message-ID: <20131204144010.GA26581@lee--X1>
References: <cover.1386108712.git.stefan@agner.ch>
 <127fe07e18665f93aa8d7c03e03164f1a049ddb6.1386108712.git.stefan@agner.ch>
 <20131204121424.GN29268@sirena.org.uk>
 <0983a0fa016faa5674834afad4472413@agner.ch>
 <20131204142954.GW29268@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20131204142954.GW29268@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > Acked-by: Mark Brown <broonie@linaro.org>
> 
> > > I won't apply since I think that patch 3 needs to go along with this,
> > > unless people decide the regulator tree is the easiest way to merge.
> 
> > I merged the dependent DT changes into that patch, so from my side,
> > patch 3 don't needs to go along with this...
> 
> OK, though now I look I see it also depends on patch 1 itself so at
> least those two will need to go together.

Well as I've already applied patch 1, I can take this too, no problem.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
