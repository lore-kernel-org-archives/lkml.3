Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751066Ab3HSPQI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 11:16:08 -0400
Received: from mga01.intel.com ([192.55.52.88]:19602 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750907Ab3HSPQH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 11:16:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,913,1367996400"; 
   d="scan'208";a="388517118"
Message-ID: <1376925707.2089.493.camel@sauron.fi.intel.com>
Subject: Re: [PATCH] UBI: Fix PEB leak in wear_leveling_worker()
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Richard Weinberger <richard@nod.at>
Cc: dwmw2@infradead.org, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Date: Mon, 19 Aug 2013 18:21:47 +0300
In-Reply-To: <1376894892-31519-1-git-send-email-richard@nod.at>
References: <1376894892-31519-1-git-send-email-richard@nod.at>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-08-19 at 08:48 +0200, Richard Weinberger wrote:
> get_peb_for_wl() removes the PEB from the free list.
> If the WL subsystem detects that no wear leveling is needed
> it cancels the operation and drops the gained PEB.
> In this case we have to put the PEB back into the free list.
> 
> This issue was introduced with commit ed4b7021c
> (UBI: remove PEB from free tree in get_peb_for_wl()).
> 
> Cc: <stable@vger.kernel.org> # 3.7.x
> Signed-off-by: Richard Weinberger <richard@nod.at>

Pushed to linux-ubi.git, thanks.

And special thanks for taking care about Ccing -stable.

-- 
Best Regards,
Artem Bityutskiy

