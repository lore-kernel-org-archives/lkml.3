Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754299Ab3HBP4H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 11:56:07 -0400
Received: from mga14.intel.com ([143.182.124.37]:27099 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752972Ab3HBP4F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 11:56:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,802,1367996400"; 
   d="scan'208";a="340757089"
Message-ID: <1375459275.14869.353.camel@sauron.fi.intel.com>
Subject: Re: [PATCH] mtd: diskonchip: remove unused entries in Kconfig
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Reply-To: artem.bityutskiy@linux.intel.com
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Cc: dwmw2@infradead.org, rdunlap@infradead.org, robert.jarzmik@free.fr,
        keescook@chromium.org, shijie8@gmail.com, arnd@arndb.de,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Fri, 02 Aug 2013 19:01:15 +0300
In-Reply-To: <1373258360-22702-1-git-send-email-michael.opdenacker@free-electrons.com>
References: <1373258360-22702-1-git-send-email-michael.opdenacker@free-electrons.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-07-08 at 06:39 +0200, Michael Opdenacker wrote:
> This patch proposes to remove kernel configuration parameters
> defined in drivers/mtd/devices/Kconfig, but used nowhere
> in the makefiles and source code (except in comments).
> 
> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>

Pushed to l2-mtd.git, thanks! 

-- 
Best Regards,
Artem Bityutskiy

