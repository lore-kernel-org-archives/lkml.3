Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753055AbaFGQTl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2014 12:19:41 -0400
Received: from lnfm1.sai.msu.ru ([93.180.26.255]:48061 "EHLO lnfm1.sai.msu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752930AbaFGQTj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2014 12:19:39 -0400
Date: Sat, 7 Jun 2014 20:19:26 +0400 (MSK)
From: "Matwey V. Kornilov" <matwey@sai.msu.ru>
To: Robert Nelson <robertcnelson@gmail.com>
cc: Benoit Cousson <bcousson@baylibre.com>,
        "tony@atomide.com" <tony@atomide.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] dts: Add UARTs to am335x-bone-common.dtsi
In-Reply-To: <CAOCHtYjFT_96wxbsAUY4-aKAC7LmqVpFEGDfyLTODFQ-uy9e+A@mail.gmail.com>
Message-ID: <alpine.LRH.2.00.1406072017510.15288@lnfm1.sai.msu.ru>
References: <alpine.LRH.2.00.1406071845220.13290@lnfm1.sai.msu.ru> <CAOCHtYjFT_96wxbsAUY4-aKAC7LmqVpFEGDfyLTODFQ-uy9e+A@mail.gmail.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 7 Jun 2014, Robert Nelson wrote:
> These need to stay disabled in mainline, so drop the status = "okay";
> , (till we get a working capemgr/overlay). Otherwise the pinmuxing
> looks good.

What chances that we will eventually have working overlay in the mainline?
