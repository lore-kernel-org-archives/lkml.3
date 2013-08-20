Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751454Ab3HTOyz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 10:54:55 -0400
Received: from mga11.intel.com ([192.55.52.93]:56915 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751111Ab3HTOyy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 10:54:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,921,1367996400"; 
   d="scan'208";a="389160434"
Message-ID: <1377010839.2089.571.camel@sauron.fi.intel.com>
Subject: Re: [PATCH] UBI: Fix invalidate_fastmap()
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Richard Weinberger <richard@nod.at>
Cc: dwmw2@infradead.org, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Tue, 20 Aug 2013 18:00:39 +0300
In-Reply-To: <1376944309-11342-1-git-send-email-richard@nod.at>
References: <1376944309-11342-1-git-send-email-richard@nod.at>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-08-19 at 22:31 +0200, Richard Weinberger wrote:
> Onging tests uncovered that invalidate_fastmap() is broken.
> It must not call ubi_wl_put_fm_peb() because all PEBs used
> by the old fastmap have already been put back.
> 
> Signed-off-by: Richard Weinberger <richard@nod.at>

Pushed to linux-ubi.git, thanks!

-- 
Best Regards,
Artem Bityutskiy

