Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934590Ab3DKX0I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 19:26:08 -0400
Received: from mga09.intel.com ([134.134.136.24]:33475 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933864Ab3DKX0F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 19:26:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,458,1363158000"; 
   d="scan'208";a="293743774"
Message-ID: <1365722761.2183.7.camel@rzhang1-mobl4>
Subject: Re: [PATCH 14/30] thermal/exynos: remove unnecessary header
 inclusions
From: Zhang Rui <rui.zhang@intel.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org
Date: Fri, 12 Apr 2013 07:26:01 +0800
In-Reply-To: <51660F85.4000105@ti.com>
References: <1365638712-1028578-1-git-send-email-arnd@arndb.de>
	 <1365638712-1028578-15-git-send-email-arnd@arndb.de>
	 <51660F85.4000105@ti.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-04-10 at 21:19 -0400, Eduardo Valentin wrote:
> Rui, Arnd,
> 
> As agreed in [1], I will be helping on the thermal maintenance.
> 
> On 10-04-2013 20:04, Arnd Bergmann wrote:
> > In multiplatform configurations, we cannot include headers
> > provided by only the exynos platform. Fortunately a number
> > of drivers that include those headers do not actually need
> > them, so we can just remove the inclusions.
> >
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > Cc: linux-pm@vger.kernel.org
> > Cc: Zhang Rui <rui.zhang@intel.com>
> 
> This patch looks good to me.
> 
> You can add my:
> Acked-by: Eduardo Valentin <eduardo.valentin@ti.com>
> 
applied to thermal thermal branch.

thanks,
rui
> 
> [1] - http://marc.info/?l=linux-pm&m=136560509922173&w=2


