Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293AbaKEDYK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 22:24:10 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37315 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752039AbaKEDYI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 22:24:08 -0500
Message-ID: <54599853.9050706@suse.de>
Date: Wed, 05 Nov 2014 04:24:03 +0100
From: =?UTF-8?B?QW5kcmVhcyBGw6RyYmVy?= <afaerber@suse.de>
Organization: SUSE LINUX Products GmbH
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Soren Brinkmann <soren.brinkmann@xilinx.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Heiko Stuebner <heiko@sntech.de>, linux-sh@vger.kernel.org,
        Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        linux-rockchip@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        Alessandro Rubini <rubini@unipv.it>
Subject: Re: [PATCH 5/7] pinctrl: Add driver for Zynq
References: <1415041531-15520-1-git-send-email-soren.brinkmann@xilinx.com> <1415041531-15520-6-git-send-email-soren.brinkmann@xilinx.com>
In-Reply-To: <1415041531-15520-6-git-send-email-soren.brinkmann@xilinx.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Am 03.11.2014 um 20:05 schrieb Soren Brinkmann:
> +	PINCTRL_PIN(54, "EMIO_SD0_WP"),
> +	PINCTRL_PIN(55, "EMIO_SD0_CD"),
> +	PINCTRL_PIN(56, "EMIO_SD1_WP"),
> +	PINCTRL_PIN(57, "EMIO_SD0_CD"),

Should this be "EMIO_SD1_CD"?

Regards,
Andreas

-- 
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg, Germany
GF: Jeff Hawn, Jennifer Guild, Felix Imendörffer; HRB 21284 AG Nürnberg
