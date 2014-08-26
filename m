Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934318AbaHZJUy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 05:20:54 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:50887 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932752AbaHZJUx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 05:20:53 -0400
Message-ID: <53FC514F.6060206@ti.com>
Date: Tue, 26 Aug 2014 14:50:15 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
CC: <linux@arm.linux.org.uk>, <vinod.koul@intel.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>
Subject: Re: [PATCH] ARM: edma: Fix configuration parsing for SoCs with multiple
 eDMA3 CC
References: <1407155216-20267-1-git-send-email-peter.ujfalusi@ti.com>
In-Reply-To: <1407155216-20267-1-git-send-email-peter.ujfalusi@ti.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 04 August 2014 05:56 PM, Peter Ujfalusi wrote:
> The edma_setup_from_hw() should know about the CC number when parsing the
> CCCFG register - when it reads the register to be precise. The base
> addresses for CCs stored in an array and we need to provide the correct id
> to edma_read() in order to read the correct register.
> 
> Cc: <stable@vger.kernel.org> # 3.16
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>

Applied and will queue for v3.17-rc

Thanks,
Sekhar
