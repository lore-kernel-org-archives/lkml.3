Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750787Ab3HSNcq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 09:32:46 -0400
Received: from mga09.intel.com ([134.134.136.24]:48678 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750705Ab3HSNco (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 09:32:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,913,1367996400"; 
   d="scan'208";a="389506313"
Message-ID: <1376919489.2089.464.camel@sauron.fi.intel.com>
Subject: Re: [PATCH 3/6] mtd: fsmc_nand: simplify
 platform_get_resource_byname/devm_ioremap_resource
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 19 Aug 2013 16:38:09 +0300
In-Reply-To: <1376902316-18520-4-git-send-email-Julia.Lawall@lip6.fr>
References: <1376902316-18520-1-git-send-email-Julia.Lawall@lip6.fr>
	 <1376902316-18520-4-git-send-email-Julia.Lawall@lip6.fr>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-08-19 at 10:51 +0200, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> Remove unneeded error handling on the result of a call to
> platform_get_resource_byname when the value is passed to devm_ioremap_resource.
> 
> A simplified version of the semantic patch that makes this change is as
> follows: (http://coccinelle.lip6.fr/)

Pushed to l2-mtd.git, thanks.

-- 
Best Regards,
Artem Bityutskiy

