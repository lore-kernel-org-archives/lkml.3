Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933921Ab3BMNNk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 08:13:40 -0500
Received: from mga02.intel.com ([134.134.136.20]:59310 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759204Ab3BMNNi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 08:13:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,657,1355126400"; 
   d="scan'208";a="285180039"
Message-ID: <1360761230.12703.150.camel@sauron.fi.intel.com>
Subject: Re: [PATCH] mtd: davinci_nand: Use managed resources
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Reply-To: artem.bityutskiy@linux.intel.com
To: Mrugesh Katepallewar <mrugesh.mk@ti.com>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        davinci-linux-open-source@linux.davincidsp.com, dwmw2@infradead.org,
        m-karicheri2@ti.com, mturquette@linaro.org, nsekhar@ti.com
Date: Wed, 13 Feb 2013 15:13:50 +0200
In-Reply-To: <1360233195-8575-1-git-send-email-mrugesh.mk@ti.com>
References: <1360233195-8575-1-git-send-email-mrugesh.mk@ti.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3 (3.6.3-2.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-02-07 at 16:03 +0530, Mrugesh Katepallewar wrote:
> davinci_nand driver currently uses normal kzalloc, ioremap and get_clk
> routines. This patch replaces these routines with devm_kzalloc,
> devm_request_and_ioremap and devm_clk_get resp.
> 
> Signed-off-by: Mrugesh Katepallewar <mrugesh.mk@ti.com>

Pushed to l2-mtd.git, thanks!

P.S. you could also kill the unneeded duplicated labels, but this is not
a big deal.

-- 
Best Regards,
Artem Bityutskiy

