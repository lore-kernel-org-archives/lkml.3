Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758749Ab3EOMJS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 08:09:18 -0400
Received: from mga02.intel.com ([134.134.136.20]:54561 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752853Ab3EOMJQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 08:09:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,677,1363158000"; 
   d="scan'208";a="337638464"
Message-ID: <1368619917.15764.99.camel@sauron.fi.intel.com>
Subject: Re: [PATCH v5 01/11] mtd: add datasheet's ECC information to
 nand_chip{}
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Huang Shijie <b32955@freescale.com>
Cc: dwmw2@infradead.org, computersforpeace@gmail.com,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Wed, 15 May 2013 15:11:57 +0300
In-Reply-To: <1368607232-2210-2-git-send-email-b32955@freescale.com>
References: <1368607232-2210-1-git-send-email-b32955@freescale.com>
	 <1368607232-2210-2-git-send-email-b32955@freescale.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-05-15 at 16:40 +0800, Huang Shijie wrote:
> + * @ecc_strength:	[INTERN] ECC correctability from the datasheet.
> + *			Minimum amount of bit errors per @ecc_step guaranteed to
> + *			be correctable. If unknown, set to zero.
> + * @ecc_step:		[INTERN] ECC step required by the @ecc_strength,
> + *                      also from the datasheet. It is the recommended ECC step
> + *			size, if known; if unknown, set to zero.

Here and in other places you talk about "datasheet". Do you assume that
the real ECC strength/step used by NAND chips may be different? Or you
assume it must be the same?

-- 
Best Regards,
Artem Bityutskiy

