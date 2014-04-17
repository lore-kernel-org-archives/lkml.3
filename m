Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754288AbaDQG6A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 02:58:00 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:33439 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751465AbaDQG56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 02:57:58 -0400
Date: Thu, 17 Apr 2014 07:57:53 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: Matt Porter <mporter@linaro.org>,
        Devicetree List <devicetree@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Tim Kryger <tim.kryger@linaro.org>,
        Markus Mayer <markus.mayer@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 2/4] mfd: bcm590xx: add support for second i2c slave
 address space
Message-ID: <20140417065753.GC28725@lee--X1>
References: <1397501428-8857-1-git-send-email-mporter@linaro.org>
 <1397501428-8857-3-git-send-email-mporter@linaro.org>
 <20140416110603.GA19671@lee--X1>
 <20140416213141.GD12304@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140416213141.GD12304@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > s/regmap/Regmap
> 
> It's consistently written regmap in all the documentation and so on :)

Furry muff; but the comments still stand for the acronyms.

> > addmap{0,1} doesn't quite sit right with me.
> 
> > REVISIT: Ah, it's address-map, rather than add map. Okay, not as bad
> > as I first thought, but still, is there a better naming convention you
> > could use?
> 
> addrmap or something?

Right, that was what I was thinking. However, I prefer something along
the lines of 'i2c' and 'i2c_sec' or 'client' and 'client_slv' etc.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
