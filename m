Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751647Ab3EPJdu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 05:33:50 -0400
Received: from mga02.intel.com ([134.134.136.20]:27238 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750926Ab3EPJdt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 05:33:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,683,1363158000"; 
   d="scan'208";a="314531585"
Message-ID: <1368696992.15764.188.camel@sauron.fi.intel.com>
Subject: Re: [PATCH v5 01/11] mtd: add datasheet's ECC information to
 nand_chip{}
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Huang Shijie <b32955@freescale.com>
Cc: dwmw2@infradead.org, computersforpeace@gmail.com,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Thu, 16 May 2013 12:36:32 +0300
In-Reply-To: <51949378.6020005@freescale.com>
References: <1368607232-2210-1-git-send-email-b32955@freescale.com>
			 <1368607232-2210-2-git-send-email-b32955@freescale.com>
		 <1368619917.15764.99.camel@sauron.fi.intel.com>
		 <51944184.7090107@freescale.com>
	 <1368688465.15764.172.camel@sauron.fi.intel.com>
	 <51949378.6020005@freescale.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-05-16 at 16:06 +0800, Huang Shijie wrote:
> what's about add the "_datasheet" for these two fields?
> such as
> 
> ecc_strength__datasheet;ecc_step__datasheet

May be, if these are not too long names. Or ecc_ds_strignth /
ecc_ds_step, for example.

-- 
Best Regards,
Artem Bityutskiy

