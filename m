Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754678Ab3JCPA2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 11:00:28 -0400
Received: from mga09.intel.com ([134.134.136.24]:38571 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753995Ab3JCPA1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 11:00:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1026,1371106800"; 
   d="scan'208";a="387360871"
Message-ID: <1380812414.27358.440.camel@sauron.fi.intel.com>
Subject: Re: [PATCH 1/7] UBI: fix refill_wl_user_pool()
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Richard Weinberger <richard@nod.at>
Cc: richard.genoud@gmail.com, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Thu, 03 Oct 2013 18:00:14 +0300
In-Reply-To: <1380376516-30144-2-git-send-email-richard@nod.at>
References: <1380376516-30144-1-git-send-email-richard@nod.at>
	 <1380376516-30144-2-git-send-email-richard@nod.at>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-09-28 at 15:55 +0200, Richard Weinberger wrote:
> If no free PEBs are available refill_wl_user_pool() must not
> return with -ENOSPC immediately.
> It has to block till produce_free_peb() produced a free PEB.
> 
> Reported-and-Tested-by: Richard Genoud <richard.genoud@gmail.com>
> Signed-off-by: Richard Weinberger <richard@nod.at>

What is pool size, I wonder?

-- 
Best Regards,
Artem Bityutskiy

