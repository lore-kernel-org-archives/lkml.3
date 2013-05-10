Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757247Ab3EJOkx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 10:40:53 -0400
Received: from mga02.intel.com ([134.134.136.20]:32555 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755058Ab3EJOku (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 10:40:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,648,1363158000"; 
   d="scan'208";a="334888810"
Message-ID: <1368197016.26780.171.camel@sauron.fi.intel.com>
Subject: Re: [PATCH] drivers: mtd: devices: convert to
 devm_ioremap_resource()
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Reply-To: artem.bityutskiy@linux.intel.com
To: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
Cc: linux-mtd@lists.infradead.org, David Woodhouse <dwmw2@infradead.org>,
        Philip Avinash <avinashphilip@ti.com>,
        Peter Korsgaard <jacmet@sunsite.dk>, linux-kernel@vger.kernel.org
Date: Fri, 10 May 2013 17:43:36 +0300
In-Reply-To: <1365627711-17476-1-git-send-email-silviupopescu1990@gmail.com>
References: <1365627711-17476-1-git-send-email-silviupopescu1990@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-04-11 at 00:01 +0300, Silviu-Mihai Popescu wrote:
> Convert all uses of devm_request_and_ioremap() to the newly introduced
> devm_ioremap_resource() which provides more consistent error handling.
> 
> Signed-off-by: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>

Pushed to l2-mtd.git, thanks!

-- 
Best Regards,
Artem Bityutskiy

