Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007Ab3HBPcZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 11:32:25 -0400
Received: from mga14.intel.com ([143.182.124.37]:48259 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753916Ab3HBPcQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 11:32:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,802,1367996400"; 
   d="scan'208";a="276852997"
Message-ID: <1375457848.14869.345.camel@sauron.fi.intel.com>
Subject: Re: [PATCH 06/12] drivers/mtd/nand/gpmi-nand: don't use
 devm_pinctrl_get_select_default() in probe
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Reply-To: artem.bityutskiy@linux.intel.com
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
        Huang Shijie <b32955@freescale.com>,
        Bill Pemberton <wfp5p@virginia.edu>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        linux-mtd@lists.infradead.org
Date: Fri, 02 Aug 2013 18:37:28 +0300
In-Reply-To: <1373471889-18107-6-git-send-email-wsa@the-dreams.de>
References: <1373471889-18107-1-git-send-email-wsa@the-dreams.de>
	 <1373471889-18107-6-git-send-email-wsa@the-dreams.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-07-10 at 16:57 +0100, Wolfram Sang wrote:
> Since commit ab78029 (drivers/pinctrl: grab default handles from device core),
> we can rely on device core for setting the default pins. Compile tested only.
> 
> Acked-by: Linus Walleij <linus.walleij@linaro.org> (personally at LCE13)
> Signed-off-by: Wolfram Sang <wsa@the-dreams.de>

Pushed to l2-mtd.git, thanks!

-- 
Best Regards,
Artem Bityutskiy

