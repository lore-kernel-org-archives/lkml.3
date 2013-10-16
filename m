Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760114Ab3JPIPr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 04:15:47 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:39236 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753604Ab3JPIPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 04:15:42 -0400
Date: Wed, 16 Oct 2013 16:15:32 +0800
From: Adam Lee <adam.lee@canonical.com>
To: Peter Guo <peter.guo@bayhubtech.com>, Chris Ball <cjb@laptop.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bill Pemberton <wfp5p@virginia.edu>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Samuel Guan <samuel.guan@bayhubtech.com>,
        Xiaoguang Yu <xiaoguang.yu@bayhubtech.com>,
        Shirley Her <shirley.her@bayhubtech.com>,
        Yuxiang Wan <yuxiang.wan@bayhubtech.com>
Subject: Re: [PATCH v2] mmc:sdhci-pci: Add Support of O2Mirco/BayHubTech SD
 Host
Message-ID: <20131016081532.GB3416@adam-laptop>
References: <97254cf7c23548fdbb3ebc10170af6a8@BL2PR04MB083.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <97254cf7c23548fdbb3ebc10170af6a8@BL2PR04MB083.namprd04.prod.outlook.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 16, 2013 at 07:26:23AM +0000, Peter Guo wrote:
> Add O2Micro/BayHubTech SD Host DeviceId 8520 support and specified Init.
> Apply SDHCI_QUIRK_MULTIBLOCK_READ_ACMD12 for SD Host Controller.
> Apply SDHCI_QUIRK_NO_ENDATTR_IN_NOPDESC for SD Host Controller.
> 
> Signed-off-by: peter.guo <peter.guo@bayhubtech.com>
> ---
>  drivers/mmc/host/sdhci-pci.c |  208 ++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 208 insertions(+)

I'm enabling "O2 Micro, Inc. Device [1217:8520]" on some laptops, it
works after this patch applied.

Chris, please take a look? Thanks.

Tested-by: Adam Lee <adam.lee@canonical.com>

-- 
Adam Lee
