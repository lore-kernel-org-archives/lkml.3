Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966041Ab3E2MhL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 08:37:11 -0400
Received: from mga11.intel.com ([192.55.52.93]:9502 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965709Ab3E2MhJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 08:37:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,763,1363158000"; 
   d="scan'208";a="341932610"
Message-ID: <1369831198.24286.24.camel@sauron.fi.intel.com>
Subject: Re: [PATCH V2] drivers: mtd: nand: davinci: use
 devm_ioremap_resource()
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Reply-To: artem.bityutskiy@linux.intel.com
To: Laurent Navet <laurent.navet@gmail.com>
Cc: dwmw2@infradead.org, sshtylyov@ru.mvista.com, m-karicheri2@ti.com,
        mturquette@linaro.org, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Wed, 29 May 2013 15:39:58 +0300
In-Reply-To: <1367502970-28642-1-git-send-email-laurent.navet@gmail.com>
References: <1367502970-28642-1-git-send-email-laurent.navet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-05-02 at 15:56 +0200, Laurent Navet wrote:
> Replace a call to deprecated devm_request_and_ioremap by devm_ioremap_resource.
> 
> Found with coccicheck and this semantic patch:
>  scripts/coccinelle/api/devm_request_and_ioremap.cocci.
> 
> Signed-off-by: Laurent Navet <laurent.navet@gmail.com>

Pushed to l2-mtd.git, thanks!

-- 
Best Regards,
Artem Bityutskiy

