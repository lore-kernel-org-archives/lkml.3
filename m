Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753016Ab3J2IQy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 04:16:54 -0400
Received: from gloria.sntech.de ([95.129.55.99]:57450 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752043Ab3J2IQw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 04:16:52 -0400
From: Heiko =?iso-8859-1?q?St=FCbner?= <heiko@sntech.de>
To: Wim Van Sebroeck <wim@iguana.be>
Subject: Re: [PATCH 0/3] watchdog: dw_wdt: common clock framework and devicetree support
Date: Tue, 29 Oct 2013 09:16:42 +0100
User-Agent: KMail/1.13.7 (Linux/3.2.0-3-686-pae; KDE/4.8.4; i686; ; )
Cc: Jamie Iles <jamie@jamieiles.com>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org
References: <201306262003.13256.heiko@sntech.de> <20131029073255.GA19569@spo001.leaseweb.com>
In-Reply-To: <20131029073255.GA19569@spo001.leaseweb.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201310290916.43425.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wim,

Am Dienstag, 29. Oktober 2013, 08:32:55 schrieb Wim Van Sebroeck:
> > This small series changes the dw_wdt driver, so that it is usable on
> > machines using the common clock framework (needs the clk to be prepared)
> > and devicetree (needs a binding).
> > 
> > Heiko Stuebner (3):
> >   watchdog: dw_wdt: convert to SIMPLE_DEV_PM_OPS
> >   watchdog: dw_wdt: use clk_prepare_enable and clk_disable_unprepare
> >   watchdog: dw_wdt: add a devicetree binding
> >  
> >  .../bindings/watchdog/snps-dw-apb-wdt.txt          |   18 ++++++++++++
> >  drivers/watchdog/dw_wdt.c                          |   31
> >  ++++++++++++-------- 2 files changed, 36 insertions(+), 13 deletions(-)
> >  create mode 100644
> >  Documentation/devicetree/bindings/watchdog/snps-dw-apb-wdt.txt
> 
> patches 1 and 2 have been added to linux-watchdog-next.
> Patch 3 has been replaced with Dinh Nguyen's patch (watchdog: dw: Enable OF
> support for DW watchdog timer).

cool ... totally forgot about this series.

Shared IPs-blocks are a nice thing, making stuff not depend on individual lazy 
developers [like me this time ;-) ]


Heiko
