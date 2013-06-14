Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752403Ab3FNPxR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 11:53:17 -0400
Received: from multi.imgtec.com ([194.200.65.239]:26333 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751764Ab3FNPxN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 11:53:13 -0400
Message-ID: <51BB3C62.4070000@imgtec.com>
Date: Fri, 14 Jun 2013 16:53:06 +0100
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: =?UTF-8?B?SGVpa28gU3TDvGJuZXI=?= <heiko@sntech.de>
CC: Linus Walleij <linus.walleij@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>, <rob.herring@calxeda.com>,
        <devicetree-discuss@lists.ozlabs.org>,
        "Laurent Pinchart" <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH 0/5] pinctrl: fix some issues with new pinconfig dt parsing
References: <201306141741.46077.heiko@sntech.de>
In-Reply-To: <201306141741.46077.heiko@sntech.de>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01192__2013_06_14_16_53_10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/06/13 16:41, Heiko Stübner wrote:
> Some issues with the recently submitted generic pinconfig parsing from dt
> came up, so fix these in this follow-up series.
> 
> Hopefully I did catch all of them.
> 
> Tested on my rk3066 device.
> 
> Heiko Stuebner (5):
>   pinctrl: update the documentation for some pinconfig params
>   pinctrl: clarify some dt pinconfig options
>   pinctrl: handle zero found dt pinconfig properties better
>   pinctrl: dynamically alloc temp array when parsing dt pinconf options

patches 1-4:
Reviewed-by: James Hogan <james.hogan@imgtec.com>

Cheers
James

>   pinctrl: rockchip: correctly handle arguments of pinconf options
> 
>  .../bindings/pinctrl/pinctrl-bindings.txt          |   22 +++++++++++-
>  drivers/pinctrl/pinconf-generic.c                  |   38 +++++++++++++++-----
>  drivers/pinctrl/pinctrl-rockchip.c                 |   37 ++++++++++++++++---
>  include/linux/pinctrl/pinconf-generic.h            |   18 ++++++----
>  4 files changed, 93 insertions(+), 22 deletions(-)
> 

