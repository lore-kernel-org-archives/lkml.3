Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754298Ab3HPOq2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 10:46:28 -0400
Received: from mga14.intel.com ([143.182.124.37]:41116 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751933Ab3HPOqU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 10:46:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,895,1367996400"; 
   d="scan'208";a="347301759"
Message-ID: <1376664710.2089.382.camel@sauron.fi.intel.com>
Subject: Re: [PATCH 4/29] mtd: simplify use of devm_ioremap_resource
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 16 Aug 2013 17:51:50 +0300
In-Reply-To: <1376471493-22215-5-git-send-email-Julia.Lawall@lip6.fr>
References: <1376471493-22215-1-git-send-email-Julia.Lawall@lip6.fr>
	 <1376471493-22215-5-git-send-email-Julia.Lawall@lip6.fr>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-08-14 at 11:11 +0200, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> Remove unneeded error handling on the result of a call to
> platform_get_resource when the value is passed to devm_ioremap_resource.
> 
> Move the call to platform_get_resource adjacent to the call to
> devm_ioremap_resource to make the connection between them more clear.

Pushed to l2-mtd.git, thanks!

-- 
Best Regards,
Artem Bityutskiy

