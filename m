Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964853Ab3CZPCh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 11:02:37 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:60362 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933653Ab3CZPCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:02:35 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: Re: [PATCH v2 4/4] dmaengine: dw_dmac: simplify master selection
Date: Tue, 26 Mar 2013 15:02:24 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-13-generic; KDE/4.3.2; x86_64; ; )
Cc: Vinod Koul <vinod.koul@intel.com>, Viresh Kumar <viresh.kumar@linaro.org>,
        linux-kernel@vger.kernel.org, "spear-devel" <spear-devel@list.st.com>,
        linux-arm-kernel@lists.infradead.org
References: <1364309637-25860-1-git-send-email-andriy.shevchenko@linux.intel.com> <1364309637-25860-5-git-send-email-andriy.shevchenko@linux.intel.com>
In-Reply-To: <1364309637-25860-5-git-send-email-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201303261502.24982.arnd@arndb.de>
X-Provags-ID: V02:K0:XXMBnf3vgpx9RUpWXJNplEyksSWWyFezPLDD1n1wqK1
 Pt8jDoRZZoPYvDVvaU9VaM3jOq3UdUFGObl9Jp6/LTvCGcuitX
 b2wuGhZK8CoRc5FsOP2hGV5nwSeQhOF1JYztldLkAzV15kV9/n
 YXFxBPX3S5vHgyybp4CDHZ+okUcB+l1QfOHCbd8p4UupLZh2mf
 pyMTFw7Kw/Fjp1IU8OVkUATIC27xVuqgGoUWNM88ZPlmbE0R5Q
 7C3X4yyUD83Ye2GdfQ1hAptJKU1Q7sKAMMilBA9io5CibInij9
 oQHqclkqfip9cziIb9aMedmZiKwJegjXX9tmjbkto2QwBBqlc/
 Ve9nus90hadJi0RBs3AU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 March 2013, Andy Shevchenko wrote:
> 
> From: Arnd Bergmann <arnd@arndb.de>
> 
> The patch to add the common DMA binding added a dummy dw_dma_slave
> structure into the dw_dma_chan structure in order to configure the
> masters correctly. It turns out that this can be simplified if we
> pick the DMA masters in the dwc_alloc_chan_resources function instead
> and save them in the dw_dma_chan structure directly.
> 
> This could be simplified further once all users that today use
> dw_dma_slave for configuration get converted to device tree based
> setup instead.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
> Cc: linux-arm-kernel@lists.infradead.org

Acked-by: Arnd Bergmann <arnd@arndb.de>
