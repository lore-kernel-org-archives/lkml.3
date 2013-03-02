Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752554Ab3CBOTH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 09:19:07 -0500
Received: from mga14.intel.com ([143.182.124.37]:64814 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752345Ab3CBOTG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 09:19:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,767,1355126400"; 
   d="scan'208";a="263492777"
Message-ID: <1362233972.2745.7.camel@sauron>
Subject: Re: [PATCH V3 1/3] mtd: add new fields to nand_flash_dev{}
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Huang Shijie <b32955@freescale.com>
Cc: dwmw2@infradead.org, computersforpeace@gmail.com,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Sat, 02 Mar 2013 16:19:32 +0200
In-Reply-To: <1359349039-11510-2-git-send-email-b32955@freescale.com>
References: <1359349039-11510-1-git-send-email-b32955@freescale.com>
	 <1359349039-11510-2-git-send-email-b32955@freescale.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3 (3.6.3-2.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-01-28 at 12:57 +0800, Huang Shijie wrote:
> As time goes on, we begin to meet the situation that we can not get enough
> information from some nand chips's id data. Take some Toshiba's nand chips
> for example. I have 4 Toshiba's nand chips in my hand:
> 	TC58NVG2S0F, TC58NVG3S0F, TC58NVG5D2, TC58NVG6D2
> 
> When we read these chips' datasheets, we will get the geometry of these chips:
> 	TC58NVG2S0F : 4096 + 224
> 	TC58NVG3S0F : 4096 + 232
> 	TC58NVG5D2  : 8192 + 640
> 	TC58NVG6D2  : 8192 + 640
> 
> But we can not parse out the correct oob size for these chips from the id data.

Very good start of the commit message - you clearly defined the problem.

> So it is time to add some new fields to the nand_flash_dev{}, and update the
> detection mechanisms.

But continued with very poor description of how you address the problem.
Please, provide a better description.

> This patch just adds some new fields to the nand_flash_dev{}:
>   @id[8] : the 8 bytes id data.

id[8] = 8 bytes id data, just like password[5] = 5 bytes of password
data. Please, provide a better commentary.

>   @id_len: the valid length of the id data.

What does "valid" mean? Are "invalid" parts?

>   @oobsize: the oob size.

Try to invent a better comment.

Huang, it is not that I am trying to be difficult, but I truly do not
understand how you are solving the issue.

-- 
Best Regards,
Artem Bityutskiy

