Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756259Ab3K0Og4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 09:36:56 -0500
Received: from mail-yh0-f53.google.com ([209.85.213.53]:43811 "EHLO
	mail-yh0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754504Ab3K0Ogw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 09:36:52 -0500
Date: Wed, 27 Nov 2013 14:36:41 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Stefan Agner <stefan@agner.ch>
Cc: swarren@wwwdotorg.org, thierry.reding@gmail.com, sameo@linux.intel.com,
        dev@lynxeye.de, mark.rutland@arm.com, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/3] mfd: tps6586x: add version detection
Message-ID: <20131127143641.GO3296@lee--X1>
References: <cover.1385508112.git.stefan@agner.ch>
 <ef881d39f78b75b4badeebb5be0264edc3906d86.1385508112.git.stefan@agner.ch>
 <20131127130954.GF3296@lee--X1>
 <cd69295e946b48451f449eacc02efa4a@agner.ch>
 <20131127135547.GK3296@lee--X1>
 <cfb203a896eda67c106794d89e668d56@agner.ch>
 <20131127143429.GN3296@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20131127143429.GN3296@lee--X1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Re-adding the list.

Please remember to 'reply to all' when discussing patches.

> > >> Hm, when the device is not answering on that request, the probe method
> > >> should fail I would say. This means that the device is missing most
> > >> likely. However, I should set the device version to TPS6586X_ANY if I
> > >> happen to end up in the default case.
> > > 
> > > I would say that returning an error is the sound thing to do, but I'm
> > > missing the point of TPS6586X_ANY, as it doesn't appear to be used in
> > > this context.
> > > 
> > 
> > Yes, its mainly used in the regulator code later on. I do assign voltage
> > table to TPS6586X_ANY, if its the appropriate table for any version of
> > the device. 
> 
> <snip>
> 
> > Ok, will change this. Setting the version to TPS6586X_ANY in the default
> > case is anyway not a good idea since it would suppress unknown versions.
> 
> Perhaps I should suggest to make TPS6586X_ANY a positive number then,
> as a negative value to me indicates more of an error than a generic
> parameter.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
