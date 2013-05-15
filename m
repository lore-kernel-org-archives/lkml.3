Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758758Ab3EOMJ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 08:09:57 -0400
Received: from mga11.intel.com ([192.55.52.93]:45719 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752853Ab3EOMJ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 08:09:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,677,1363158000"; 
   d="scan'208";a="334397367"
Message-ID: <1368619956.15764.100.camel@sauron.fi.intel.com>
Subject: Re: [PATCH v5 02/11] mtd: increase max OOB size to 744
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Huang Shijie <b32955@freescale.com>
Cc: dwmw2@infradead.org, computersforpeace@gmail.com,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Wed, 15 May 2013 15:12:36 +0300
In-Reply-To: <1368607232-2210-3-git-send-email-b32955@freescale.com>
References: <1368607232-2210-1-git-send-email-b32955@freescale.com>
	 <1368607232-2210-3-git-send-email-b32955@freescale.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-05-15 at 16:40 +0800, Huang Shijie wrote:
> The oob size of Micron's MT29F64G08CBABAWP is 744 bytes.
> So increase the NAND_MAX_OOBSIZE to 744.
> 
> Signed-off-by: Huang Shijie <b32955@freescale.com>

OK, this patch is really independent. I do not know why you put it to
this series. Let me apply it separately.

-- 
Best Regards,
Artem Bityutskiy

