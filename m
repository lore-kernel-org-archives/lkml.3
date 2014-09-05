Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345AbaIEPbY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 11:31:24 -0400
Received: from smtp-out-239.synserver.de ([212.40.185.239]:1061 "EHLO
	smtp-out-239.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752753AbaIEPbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 11:31:22 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 5520
Message-ID: <5409D74A.1000604@metafoo.de>
Date: Fri, 05 Sep 2014 17:31:22 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.7.0
MIME-Version: 1.0
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Dan Carpenter <dan.carpenter@oracle.com>, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org
CC: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH 2/3] dmaengine: pl330: Fix NULL pointer dereference on
 probe failure
References: <1409929466-29506-1-git-send-email-k.kozlowski@samsung.com> <1409929466-29506-2-git-send-email-k.kozlowski@samsung.com>
In-Reply-To: <1409929466-29506-2-git-send-email-k.kozlowski@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05/2014 05:04 PM, Krzysztof Kozlowski wrote:
> If dma_async_device_register() returns error and probe should clean up
> and return error, a NULL pointer exception happens because of
> dereference of not allocated channel thread:
>
[...]
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

Reviewed-by: Lars-Peter Clausen <lars@metafoo.de>
