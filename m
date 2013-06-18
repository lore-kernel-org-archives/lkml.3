Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754704Ab3FRIfz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 04:35:55 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:34209 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754417Ab3FRIfy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 04:35:54 -0400
Message-ID: <51C01BC3.4060100@ti.com>
Date: Tue, 18 Jun 2013 14:05:15 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
CC: Russell King <linux@arm.linux.org.uk>, Mark Brown <broonie@linaro.org>,
        Chris Ball <cjb@laptop.org>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Fernandes, Joel A" <joelagnel@ti.com>
Subject: Re: [PATCH v2] ARM: edma: Convert to devm_* api
References: <1371481078-18058-1-git-send-email-prabhakar.csengg@gmail.com>
In-Reply-To: <1371481078-18058-1-git-send-email-prabhakar.csengg@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/17/2013 8:27 PM, Prabhakar Lad wrote:
> From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
> 
> Use devm_ioremap_resource instead of reques_mem_region()/ioremap(),
> devm_request_irq() instead of request_irq() and kzalloc() calls to
> devm_kzalloc().
> 
> This ensures more consistent error values and simplifies error paths.
> 
> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Nice clean-up. The patch did not build since <linux/err.h> was not
included. I fixed it locally and applied to v3.11/soc-2 branch of my tree.

Thanks,
Sekhar
