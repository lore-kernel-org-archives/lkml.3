Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168Ab3EMH5X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 03:57:23 -0400
Received: from mga03.intel.com ([143.182.124.21]:20708 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751013Ab3EMH5W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 03:57:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,660,1363158000"; 
   d="scan'208";a="301550976"
Message-ID: <1368431995.5360.26.camel@sauron.fi.intel.com>
Subject: Re: [PATCH] mtd: Convert logging messages
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Joe Perches <joe@perches.com>
Cc: Joern Engel <joern@lazybastard.org>, David Woodhouse <dwmw2@infradead.org>,
        linux-mtd@lists.infradead.org, LKML <linux-kernel@vger.kernel.org>
Date: Mon, 13 May 2013 10:59:55 +0300
In-Reply-To: <1366394375.3901.36.camel@joe-AO722>
References: <1366394375.3901.36.camel@joe-AO722>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-04-19 at 10:59 -0700, Joe Perches wrote:
> Use a more current logging style.
> 
> Convert homegrown ERROR/INFO macros to pr_<level>.
> Convert homegrown parse_err macros to pr_err and
> expand hidden flow control.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Pushed to l2-mtd.git, thanks!

-- 
Best Regards,
Artem Bityutskiy

