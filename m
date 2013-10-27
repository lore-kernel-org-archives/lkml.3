Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201Ab3J0NDC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 09:03:02 -0400
Received: from void.printf.net ([89.145.121.20]:43459 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753498Ab3J0NDA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 09:03:00 -0400
From: Chris Ball <cjb@laptop.org>
To: Peter Guo <peter.guo@bayhubtech.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bill Pemberton <wfp5p@virginia.edu>,
        "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>,
        "linux-mmc\@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Samuel Guan <samuel.guan@bayhubtech.com>,
        Xiaoguang Yu <xiaoguang.yu@bayhubtech.com>,
        Shirley Her <shirley.her@bayhubtech.com>,
        Yuxiang Wan <yuxiang.wan@bayhubtech.com>,
        "Adam Lee" <adam.lee@canonical.com>
Subject: Re: [PATCH v2] mmc:sdhci-pci: Add Support of O2Mirco/BayHubTech SD Host
References: <97254cf7c23548fdbb3ebc10170af6a8@BL2PR04MB083.namprd04.prod.outlook.com>
	<20131016081532.GB3416@adam-laptop>
	<ba51eef0193e40df9cf25b73af6890b6@BL2PR04MB083.namprd04.prod.outlook.com>
Date: Sun, 27 Oct 2013 13:02:53 +0000
In-Reply-To: <ba51eef0193e40df9cf25b73af6890b6@BL2PR04MB083.namprd04.prod.outlook.com>
	(Peter Guo's message of "Wed, 23 Oct 2013 03:49:51 +0000")
Message-ID: <868uxeoohu.fsf@void.printf.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On Wed, Oct 23 2013, Peter Guo wrote:
> Do you have any comments on this patch?

It would be nice if there were fewer magic constants in the patch, and
adding another 200 lines to sdhci-pci seems to suggest that it might
be time to split it out into sdhci-pci-o2micro.c.

Thanks,

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
