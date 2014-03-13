Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754395AbaCMKSZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 06:18:25 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:52360 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754376AbaCMKST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 06:18:19 -0400
X-AuditID: cbfee690-b7f266d00000287c-f3-532185e22177
Message-id: <532185E2.5080204@samsung.com>
Date: Thu, 13 Mar 2014 19:18:10 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Robert Baldyga <r.baldyga@samsung.com>
Cc: sameo@linux.intel.com, lee.jones@linaro.org, myungjoo.ham@samsung.com,
        dmitry.torokhov@gmail.com, cooloney@gmail.com, rpurdie@rpsys.net,
        dbaryshkov@gmail.com, dwmw2@infradead.org, lgirdwood@gmail.com,
        broonie@kernel.org, a.zummo@towertech.it, paul.gortmaker@windriver.com,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        linux-leds@vger.kernel.org, rtc-linux@googlegroups.com,
        m.szyprowski@samsung.com, k.kozlowski@samsung.com
Subject: Re: [PATCH v3 3/4] mfd: max8997: change irq names to upper case
References: <1394703532-494-1-git-send-email-r.baldyga@samsung.com>
 <1394703532-494-4-git-send-email-r.baldyga@samsung.com>
In-reply-to: <1394703532-494-4-git-send-email-r.baldyga@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKKsWRmVeSWpSXmKPExsWyRsSkSPdRq2KwwZtHhhZLLl5lt5j68Amb
	xdGdE5ksJj15z2xxeNELRouJKyczW7x+YWhx/+tRRotvVzqYLG5++sZqcXnXHDaLrW/WMVqs
	PXKX3eJ24wo2i2t7jzNbPDi8k91i966nrBb7OzsYLU53szoIe+ycdZfdY8/Ek2wem1doeWxa
	1cnmcefaHjaPeScDPfbM/8Hq0bdlFaPH9Hk/mTw+b5LzWL9lK1MAdxSXTUpqTmZZapG+XQJX
	xvdfF9gLjrFUnF/0gb2B8R5zFyMnh4SAicSuWy2sELaYxIV769m6GLk4hASWMkpceruLCaZo
	27vjzBCJRYwSEzb2sUA4rxglHi08xAZSxSugJfF21hOwDhYBVYlz706CrWADiu9/cQOsRlQg
	TGLl9CssEPWCEj8m3wOzRYBq7nyczw5iMwscZZZ43yAHYgsLeEic3nESLC4kUCvxvuk/2HxO
	AReJ4y9+M0HU60jsb53GBmHLS2xe8xbsUgmBMxwSB75fYYU4SEDi2+RDQMs4gBKyEpsOQL0v
	KXFwxQ2WCYxis5CcNAvJ2FlIxi5gZF7FKJpakFxQnJReZKJXnJhbXJqXrpecn7uJEZgkTv97
	NmEH470D1ocYk4FWTmSWEk3OByaZvJJ4Q2MzIwtTE1NjI3NLM9KElcR51R4lBQkJpCeWpGan
	phakFsUXleakFh9iZOLglGpgZDzWeef+wkCrM5P55h898FLv7rMs1bcNCr/knHR1bN79Fyqd
	KuKw78ztOU5Fchs2LFb/vP8aQ9Jrx5+bmbw45q4qvtJ4wVJW+nFChMjy8AvF9tt/vnT/ah3O
	zf7oi7Fn1sZ17+qTZCcuD/AQkKsIWVbfqvy2je/J1XX+p9mbMjRkmf355wn0KbEUZyQaajEX
	FScCABLXYuMoAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrEKsWRmVeSWpSXmKPExsVy+t9jAd1HrYrBBjvXa1gsuXiV3WLqwyds
	Fkd3TmSymPTkPbPF4UUvGC0mrpzMbPH6haHF/a9HGS2+Xelgsrj56RurxeVdc9gstr5Zx2ix
	9shddovbjSvYLK7tPc5s8eDwTnaL3bueslrs7+xgtDjdzeog7LFz1l12jz0TT7J5bF6h5bFp
	VSebx51re9g85p0M9Ngz/werR9+WVYwe0+f9ZPL4vEnOY/2WrUwB3FENjDYZqYkpqUUKqXnJ
	+SmZeem2St7B8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5QN8pKZQl5pQChQISi4uV9O0w
	TQgNcdO1gGmM0PUNCYLrMTJAAwlrGDO+/7rAXnCMpeL8og/sDYz3mLsYOTkkBEwktr07DmWL
	SVy4t56ti5GLQ0hgEaPEhI19LBDOK0aJRwsPsYFU8QpoSbyd9YQJxGYRUJU49+4kWDcbUHz/
	ixtgNaICYRIrp19hgagXlPgx+R6YLQJUc+fjfHYQm1ngKLPE+wY5EFtYwEPi9I6TYHEhgVqJ
	903/weZzCrhIHH/xmwmiXkdif+s0NghbXmLzmrfMExgFZiFZMQtJ2SwkZQsYmVcxiqYWJBcU
	J6XnGuoVJ+YWl+al6yXn525iBKegZ1I7GFc2WBxiFOBgVOLhXbFcIViINbGsuDL3EKMEB7OS
	CC9rs2KwEG9KYmVValF+fFFpTmrxIcZkYAhMZJYSTc4Hpse8knhDYxMzI0sjc0MLI2Nz0oSV
	xHkPtFoHCgmkJ5akZqemFqQWwWxh4uCUamDkag04ZabpeWX59hDx1F2tc63UwsO77j47GaR2
	WtNviqV7JV/YvEuZBSc8tsx5dtuCeW1ymPT75NDZ9pbaMVbrLWftere6drbnszW7F7Yaerw4
	6D69eqV+2TYX5u7szR07b696nbWo/1ZI/MJ8k4Or2jiW7tBe/Zx30r9fYj0mu9dIb7KsK+xX
	YinOSDTUYi4qTgQAIE3zyIUDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/13/2014 06:38 PM, Robert Baldyga wrote:
> This patch changes naming convention of MUIC interrupts form CamelCase
> to upper case. It makes names more readable and consistent with another
> interrupt names in max8997 driver.
> 
> Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
> ---
>  drivers/extcon/extcon-max8997.c     |   32 ++++++++++++++++----------------
>  include/linux/mfd/max8997-private.h |   16 ++++++++--------
>  2 files changed, 24 insertions(+), 24 deletions(-)
> 

Acked-by: Chanwoo Choi <cw00.choi@samsung.com>

Thanks,
Chanwoo Choi

