Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932068AbaESNCs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 09:02:48 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:37932 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754611AbaESNCq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 09:02:46 -0400
Message-ID: <537A00CA.2060009@ti.com>
Date: Mon, 19 May 2014 18:32:02 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Peter Ujfalusi <peter.ujfalusi@ti.com>, <joelf@ti.com>, <arnd@arndb.de>
CC: <linux@arm.linux.org.uk>, <vinod.koul@intel.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <tony@atomide.com>,
        <bcousson@baylibre.com>
Subject: Re: [PATCH v3 05/13] ARM/platform_data: edma: Remove queue_tc_mapping
 data from edma_soc_info
References: <1400242640-9902-1-git-send-email-peter.ujfalusi@ti.com> <1400242640-9902-6-git-send-email-peter.ujfalusi@ti.com>
In-Reply-To: <1400242640-9902-6-git-send-email-peter.ujfalusi@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 16 May 2014 05:47 PM, Peter Ujfalusi wrote:
> It is no longer in use by the driver or board files.
> 
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>

I dropped the /platform_data in subject like to keep it consistent with
what has been done for this file so far. Even looking at logs for other
files in this directory there is no such convention.

Same thing for 13/13.

Thanks,
Sekhar

