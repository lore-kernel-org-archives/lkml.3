Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753515Ab3HBOqf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 10:46:35 -0400
Received: from mga02.intel.com ([134.134.136.20]:45233 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751138Ab3HBOqe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 10:46:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,801,1367996400"; 
   d="scan'208";a="380821834"
Message-ID: <1375455107.14869.326.camel@sauron.fi.intel.com>
Subject: Re: [PATCH resend] MTD: atmel_nand: using a stronger ECC is not
 dangerous
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Reply-To: artem.bityutskiy@linux.intel.com
To: Richard Genoud <richard.genoud@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>, Josh Wu <josh.wu@atmel.com>,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Fri, 02 Aug 2013 17:51:47 +0300
In-Reply-To: <1375197449-32370-1-git-send-email-richard.genoud@gmail.com>
References: <1375197449-32370-1-git-send-email-richard.genoud@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-07-30 at 17:17 +0200, Richard Genoud wrote:
> We don't have to issue a warning when a stronger error correting
> capability is chosen.
> 
> Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
> Acked-by: Josh Wu <josh.wu@atmel.com>

Pushed to l2-mtd.git, thanks!

-- 
Best Regards,
Artem Bityutskiy

