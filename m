Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753200Ab3BBHEg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 02:04:36 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:44362 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751245Ab3BBHEe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 02:04:34 -0500
Message-ID: <510CBAB7.2060100@ti.com>
Date: Sat, 2 Feb 2013 12:35:27 +0530
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Matt Porter <mporter@ti.com>
CC: Chris Ball <cjb@laptop.org>, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Vinod Koul <vinod.koul@intel.com>, Tony Lindgren <tony@atomide.com>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Dan Williams <djbw@fb.com>,
        Jon Hunter <jon-hunter@ti.com>
Subject: Re: [PATCH 1/3] mmc: omap_hsmmc: convert to dma_request_slave_channel_compat()
References: <1359752479-29427-1-git-send-email-mporter@ti.com> <1359752479-29427-2-git-send-email-mporter@ti.com>
In-Reply-To: <1359752479-29427-2-git-send-email-mporter@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 02 February 2013 02:31 AM, Matt Porter wrote:
> Convert dmaengine channel requests to use
> dma_request_slave_channel_compat(). This supports platforms booting
> with or without DT populated.
>
> Signed-off-by: Matt Porter <mporter@ti.com>
> Acked-by: Tony Lindgren <tony@atomide.com>
> ---
Acked-by: Santosh Shilimkar<santosh.shilimkar@ti.com>

