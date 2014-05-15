Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753155AbaEOMFj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 08:05:39 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:44308 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751222AbaEOMFi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 08:05:38 -0400
Message-ID: <5374AD6D.8090002@ti.com>
Date: Thu, 15 May 2014 17:35:01 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Peter Ujfalusi <peter.ujfalusi@ti.com>, <joelf@ti.com>
CC: <linux@arm.linux.org.uk>, <vinod.koul@intel.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <arm@kernel.org>
Subject: Re: [PATCH] ARM: edma: Clean up and simplify the code around irq
 request
References: <1399965961-23739-1-git-send-email-peter.ujfalusi@ti.com>
In-Reply-To: <1399965961-23739-1-git-send-email-peter.ujfalusi@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+ ARM SoC team

On Tuesday 13 May 2014 12:56 PM, Peter Ujfalusi wrote:
> Get the two interrupt line number at the same time by merging the two
> instance of if(node){}else{} places.
> replace the &pdev->dev with the already existing dev which makes it possible
> to collapse lines with devm_request_irq()
> 
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>

Acked-by: Sekhar Nori <nsekhar@ti.com>

Arnd, Olof, Kevin,

Do you mind applying this directly for v3.16? I do not have anything
else queued ATM so not sending a pull request.

Thanks,
Sekhar
