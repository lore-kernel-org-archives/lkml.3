Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932565Ab3LTNrK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 08:47:10 -0500
Received: from mail-we0-f175.google.com ([74.125.82.175]:59828 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932397Ab3LTNrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 08:47:08 -0500
Date: Fri, 20 Dec 2013 13:47:01 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Laxman Dewangan <ldewangan@nvidia.com>, anton@enomsg.org,
        dwmw2@infradead.org, mark.rutland@arm.com, rob@landley.net,
        ijc+devicetree@hellion.org.uk, swarren@nvidia.com,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mfd: AS3722: add dt node properties for system power
 controller
Message-ID: <20131220134343.GC3709@lee--X1>
References: <1387457821-12509-1-git-send-email-ldewangan@nvidia.com>
 <20131219130610.GI27373@lee--X1>
 <52B342F4.1070400@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <52B342F4.1070400@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> ams AS3722 device supports the power off by turning off its all rails.
> >>
> >> Add dt node properties to enable this functionality on this device.
> 
> >> diff --git a/Documentation/devicetree/bindings/mfd/as3722.txt b/Documentation/devicetree/bindings/mfd/as3722.txt
> 
> >> +functionality from ams AS3722:
> >> +ams,system-power-controller: To enable the power off functionality through
> >> +	device.
> > 
> > Do what with it? "on", "<1>", something else?
> 
> It's a Boolean property, so just add the name to the DT, no value.
> Admittedly the binding should state this.

I was being pedantic. ;)

> The series,
> 
> Tested-by: Stephen Warren <swarren@nvidia.com>

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
