Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934093Ab3CHNRa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 08:17:30 -0500
Received: from mga11.intel.com ([192.55.52.93]:52597 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934076Ab3CHNR3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 08:17:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,807,1355126400"; 
   d="scan'208";a="297716735"
Message-ID: <1362748695.5101.1.camel@sauron.fi.intel.com>
Subject: Re: [PATCH] mtd: maps: Remove redundant NULL check before kfree
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Syam Sidhardhan <syamsidhardh@gmail.com>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        dwmw2@infradead.org
Date: Fri, 08 Mar 2013 15:18:15 +0200
In-Reply-To: <1361908016-3110-1-git-send-email-s.syam@samsung.com>
References: <1361908016-3110-1-git-send-email-s.syam@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3 (3.6.3-2.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-02-27 at 01:16 +0530, Syam Sidhardhan wrote:
> kfree on NULL pointer is a no-op.
> 
> Signed-off-by: Syam Sidhardhan <s.syam@samsung.com>

Pushed to l2-mtd.git, thanks!

-- 
Best Regards,
Artem Bityutskiy

