Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753693Ab3COIcE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 04:32:04 -0400
Received: from mga09.intel.com ([134.134.136.24]:10921 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752357Ab3COIcA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 04:32:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,849,1355126400"; 
   d="scan'208";a="302643696"
Message-ID: <1363336377.11441.115.camel@sauron.fi.intel.com>
Subject: Re: linux-next: manual merge of the l2-mtd tree with the mtd tree
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Brian Norris <computersforpeace@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
Date: Fri, 15 Mar 2013 10:32:57 +0200
In-Reply-To: <20130315115825.6c2b7ad9c48c82640ff9f3b8@canb.auug.org.au>
References: <20130315115825.6c2b7ad9c48c82640ff9f3b8@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3 (3.6.3-2.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-03-15 at 11:58 +1100, Stephen Rothwell wrote:
> Hi Artem,
> 
> Today's linux-next merge of the l2-mtd tree got a conflict in
> include/linux/mtd/nand.h between commit 5bc7c33ca93a ("mtd: nand:
> reintroduce NAND_NO_READRDY as NAND_NEED_READRDY") from the mtd tree and
> commit edac3311879c ("mtd: nand: remove AG-AND support") from the l2-mtd
> tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Thanks Stephen, please, carry this one so far, I'll rebase my tree soon.

-- 
Best Regards,
Artem Bityutskiy

