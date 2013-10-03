Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754542Ab3JCQoS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 12:44:18 -0400
Received: from mga09.intel.com ([134.134.136.24]:37151 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754355Ab3JCQoR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 12:44:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1027,1371106800"; 
   d="scan'208";a="413600419"
Message-ID: <1380818654.18862.1.camel@sauron.fi.intel.com>
Subject: Re: UBI fastmap updates
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Richard Weinberger <richard@nod.at>
Cc: richard.genoud@gmail.com, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Thu, 03 Oct 2013 19:44:14 +0300
In-Reply-To: <1380376516-30144-1-git-send-email-richard@nod.at>
References: <1380376516-30144-1-git-send-email-richard@nod.at>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-09-28 at 15:55 +0200, Richard Weinberger wrote:
> this series is a collection of all pending UBI fastmap updates.
> 
> Richard Genoud found issues in combination with U-Boot.
> These issues also uncovered other minor issues in some error paths.
> Only one fix is not really fastmap specific and touches generic 
> UBI code, "UBI: simplify image sequence test".
> 

Pushed to linux-ubi, thanks!

-- 
Best Regards,
Artem Bityutskiy

