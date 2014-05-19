Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932468AbaESQiQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 12:38:16 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:47833 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932111AbaESQiO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 12:38:14 -0400
Message-ID: <537A3349.3030404@ti.com>
Date: Mon, 19 May 2014 19:37:29 +0300
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Sekhar Nori <nsekhar@ti.com>, <joelf@ti.com>, <arnd@arndb.de>
CC: <linux@arm.linux.org.uk>, <vinod.koul@intel.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <tony@atomide.com>,
        <bcousson@baylibre.com>
Subject: Re: [PATCH v3 02/13] ARM: edma: Take the number of tc from edma_soc_info
 (pdata)
References: <1400242640-9902-1-git-send-email-peter.ujfalusi@ti.com> <1400242640-9902-3-git-send-email-peter.ujfalusi@ti.com> <5379E5E6.9080500@ti.com>
In-Reply-To: <5379E5E6.9080500@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/19/2014 02:07 PM, Sekhar Nori wrote:
> To which baseline do the patches apply? These lines are not present at
> least in v3.15-rc5. I am applying the patch without this hunk.

It is generate on top of linux-next-20140515.
next picked up several patches since 3.15-rc and I also have my other patch in
my working branch under this series:
ARM: edma: Clean up and simplify the code around irq request

--
Péter
