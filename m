Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752168Ab3J2HdE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 03:33:04 -0400
Received: from ns1.pc-advies.be ([83.149.101.17]:39287 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751558Ab3J2HdC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 03:33:02 -0400
Date: Tue, 29 Oct 2013 08:32:55 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>
Cc: Jamie Iles <jamie@jamieiles.com>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org
Subject: Re: [PATCH 0/3] watchdog: dw_wdt: common clock framework and devicetree support
Message-ID: <20131029073255.GA19569@spo001.leaseweb.com>
References: <201306262003.13256.heiko@sntech.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201306262003.13256.heiko@sntech.de>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Heiko,

> This small series changes the dw_wdt driver, so that it is usable on
> machines using the common clock framework (needs the clk to be prepared)
> and devicetree (needs a binding).
> 
> Heiko Stuebner (3):
>   watchdog: dw_wdt: convert to SIMPLE_DEV_PM_OPS
>   watchdog: dw_wdt: use clk_prepare_enable and clk_disable_unprepare
>   watchdog: dw_wdt: add a devicetree binding
> 
>  .../bindings/watchdog/snps-dw-apb-wdt.txt          |   18 ++++++++++++
>  drivers/watchdog/dw_wdt.c                          |   31 ++++++++++++--------
>  2 files changed, 36 insertions(+), 13 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/watchdog/snps-dw-apb-wdt.txt

patches 1 and 2 have been added to linux-watchdog-next.
Patch 3 has been replaced with Dinh Nguyen's patch (watchdog: dw: Enable OF support for DW watchdog timer).

Kind regards,
Wim.

