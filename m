Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966056Ab3E2MhS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 08:37:18 -0400
Received: from mga14.intel.com ([143.182.124.37]:31970 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965709Ab3E2MhN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 08:37:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,763,1363158000"; 
   d="scan'208";a="341932742"
Message-ID: <1369831224.24286.25.camel@sauron.fi.intel.com>
Subject: Re: [PATCH] drivers: mtd: devices: elm: use devm_ioremap_resource()
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Reply-To: artem.bityutskiy@linux.intel.com
To: Laurent Navet <laurent.navet@gmail.com>
Cc: dwmw2@infradead.org, avinashphilip@ti.com, jacmet@sunsite.dk,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Wed, 29 May 2013 15:40:24 +0300
In-Reply-To: <1367507346-29382-1-git-send-email-laurent.navet@gmail.com>
References: <1367507346-29382-1-git-send-email-laurent.navet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-05-02 at 17:09 +0200, Laurent Navet wrote:
> Replace a call to deprecated devm_request_and_ioremap by devm_ioremap_resource.
> 
> Found with coccicheck and this semantic patch:
>  scripts/coccinelle/api/devm_request_and_ioremap.cocci.
> 
> Signed-off-by: Laurent Navet <laurent.navet@gmail.com>

We already have this changed in the l2-mtd.git tree:

commit f7393098da2aadf535787c74abd147aabaca491a
Author: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
Date:   Thu Apr 11 00:01:51 2013 +0300

    mtd: devices: convert to devm_ioremap_resource()
    
    Convert all uses of devm_request_and_ioremap() to the newly introduced
    devm_ioremap_resource() which provides more consistent error handling.
    
    Signed-off-by: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
    Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>


-- 
Best Regards,
Artem Bityutskiy

