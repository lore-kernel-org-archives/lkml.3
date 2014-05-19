Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754581AbaESO1E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 10:27:04 -0400
Received: from mail-ig0-f172.google.com ([209.85.213.172]:55168 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752589AbaESO1B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 10:27:01 -0400
Date: Mon, 19 May 2014 15:26:54 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: Emilio =?iso-8859-1?Q?L=F3pez?= <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Chen-Yu Tsai <wens@csie.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Shuge <shuge@allwinnertech.com>, kevin@allwinnertech.com,
        Hans de Goede <hdegoede@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, dev@linux-sunxi.org
Subject: Re: [PATCH v3 4/7] mfd: sun6i-prcm: document DT bindings
Message-ID: <20140519142654.GP4978@lee--X1>
References: <1399633911-7094-1-git-send-email-boris.brezillon@free-electrons.com>
 <1399633911-7094-5-git-send-email-boris.brezillon@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1399633911-7094-5-git-send-email-boris.brezillon@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Document DT bindings of the PRCM (Power/Reset/Clock Management) unit.
> 
> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
> ---
>  .../devicetree/bindings/mfd/sun6i-prcm.txt         | 59 ++++++++++++++++++++++
>  1 file changed, 59 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/mfd/sun6i-prcm.txt

Been on the list a while now, doesn't seem to have any potentially
controversial bindings and looks mostly fine.

Applied, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
