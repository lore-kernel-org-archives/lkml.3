Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022AbaI1MQE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 08:16:04 -0400
Received: from mga09.intel.com ([134.134.136.24]:47664 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752031AbaI1MQD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 08:16:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,614,1406617200"; 
   d="scan'208";a="609857680"
Message-ID: <1411906556.11836.26.camel@karhu>
Subject: Re: [PATCH] mtd: ubi: Extend UBI layer debug/messaging capabilities
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Tanya Brokhman <tlinder@codeaurora.org>
Cc: Richard Weinberger <richard@nod.at>, linux-arm-msm@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>,
        linux-mtd@lists.infradead.org,
        Brian Norris <computersforpeace@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
Date: Sun, 28 Sep 2014 15:15:56 +0300
In-Reply-To: <5427C5C4.40508@codeaurora.org>
References: <1411886185-7838-1-git-send-email-tlinder@codeaurora.org>
	 <5427C046.5030608@nod.at> <5427C5C4.40508@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-3.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-09-28 at 11:24 +0300, Tanya Brokhman wrote:
> This is how I first implemented this patch. But then I cam across
> some 
> ubi_err prints during the init process (in build.c ubi_init()) when
> we 
> still don't have the ubi structure, so we need to pass some number to 
> the message. I overcame this by using UBI_MAX_DEVICES.

Well, may be having two sets of wrappers would make sense then?

Or if there are few of those, just using 'printk()' would be a solution?

-- 
Best Regards,
Artem Bityutskiy

