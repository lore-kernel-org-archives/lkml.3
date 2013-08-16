Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754573Ab3HPNtV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 09:49:21 -0400
Received: from mga01.intel.com ([192.55.52.88]:62525 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751446Ab3HPNtU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 09:49:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,895,1367996400"; 
   d="scan'208";a="387317666"
Message-ID: <1376661291.2089.361.camel@sauron.fi.intel.com>
Subject: Re: [PATCH] m25p80 / fast read
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Reply-To: artem.bityutskiy@linux.intel.com
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: linux-mtd@lists.infradead.org, Marek Vasut <marex@denx.de>,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de
Date: Fri, 16 Aug 2013 16:54:51 +0300
In-Reply-To: <1376302946-11534-1-git-send-email-s.hauer@pengutronix.de>
References: <1376302946-11534-1-git-send-email-s.hauer@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-08-12 at 12:22 +0200, Sascha Hauer wrote:
> The following adds support for the mr25h10 chip to to the m25p80
> driver.
> 
> This driver currently has the problem that it unconditionally uses
> the fast_read command once it's enabled in Kconfig which of course
> leads to problems with multiboard kernels. This series adds a flag
> to the chip specific data to solve this. Also some unnecessary ifdefs
> are removed.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

I'll let Biran take a look, and tomorrow apply, unless he applies
himself or has objections.

-- 
Best Regards,
Artem Bityutskiy

