Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172Ab3HEKFv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 06:05:51 -0400
Received: from mga11.intel.com ([192.55.52.93]:29362 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751345Ab3HEKFu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 06:05:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,817,1367996400"; 
   d="scan'208";a="381381818"
Message-ID: <1375697471.14869.424.camel@sauron.fi.intel.com>
Subject: Re: [PATCH] mtd: jedec_probe: fix LH28F640BF definition
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Andrea Adami <andrea.adami@gmail.com>
Cc: linux-mtd@lists.infradead.org, David Woodhouse <dwmw2@infradead.org>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Date: Mon, 05 Aug 2013 13:11:11 +0300
In-Reply-To: <1374361653-3004-1-git-send-email-andrea.adami@gmail.com>
References: <1374361653-3004-1-git-send-email-andrea.adami@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-07-21 at 01:07 +0200, Andrea Adami wrote:
> Zaurus 5500 contains 2 LH28F640BFHE-PTTL90 (64M 4Mx16) and
> the LH28F640BFHE-PTTL90.pdf datasheet available on the net shows
> the exact erasesize and the OTP support.
> At the moment only jedec_probe can discover the chip and
> the NOR is mounted read only probably because of wrong vpp.
> 
> Signed-off-by: Andrea Adami <andrea.adami@gmail.com>

Pushed to l2-mtd.git, thanks!

-- 
Best Regards,
Artem Bityutskiy

