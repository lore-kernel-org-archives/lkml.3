Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752241Ab3CRIgf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 04:36:35 -0400
Received: from mga09.intel.com ([134.134.136.24]:58033 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751891Ab3CRIge (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 04:36:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,863,1355126400"; 
   d="scan'208";a="303712211"
Message-ID: <1363595862.20738.36.camel@sauron.fi.intel.com>
Subject: Re: [PATCH v6 0/3] mtd: use the full-id as the keyword for some
 nand chips
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Reply-To: artem.bityutskiy@linux.intel.com
To: Huang Shijie <b32955@freescale.com>
Cc: dwmw2@infradead.org, computersforpeace@gmail.com,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Mon, 18 Mar 2013 10:37:42 +0200
In-Reply-To: <1363316461-10592-1-git-send-email-b32955@freescale.com>
References: <1363316461-10592-1-git-send-email-b32955@freescale.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3 (3.6.3-2.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-03-15 at 11:00 +0800, Huang Shijie wrote:
> As time goes on, we begin to meet the situation that we can not
> get enough information from some nand chips's id data.
> Take some Toshiba's nand chips for example.
> I have 4 Toshiba's nand chips in my hand:
> 	TC58NVG2S0F, TC58NVG3S0F, TC58NVG5D2, TC58NVG6D2

Pushed to l2-mtd.git, thanks!

-- 
Best Regards,
Artem Bityutskiy

