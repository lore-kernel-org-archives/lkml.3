Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089Ab3HBPqR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 11:46:17 -0400
Received: from mga02.intel.com ([134.134.136.20]:56638 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752668Ab3HBPqQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 11:46:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,802,1367996400"; 
   d="scan'208";a="356315200"
Message-ID: <1375458661.14869.349.camel@sauron.fi.intel.com>
Subject: Re: [PATCH 05/12] drivers/mtd/nand: don't use
 devm_pinctrl_get_select_default() in probe
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Reply-To: artem.bityutskiy@linux.intel.com
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
        Josh Wu <josh.wu@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-mtd@lists.infradead.org
Date: Fri, 02 Aug 2013 18:51:01 +0300
In-Reply-To: <1373471889-18107-5-git-send-email-wsa@the-dreams.de>
References: <1373471889-18107-1-git-send-email-wsa@the-dreams.de>
	 <1373471889-18107-5-git-send-email-wsa@the-dreams.de>
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

