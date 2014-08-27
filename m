Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310AbaH0Hnu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 03:43:50 -0400
Received: from mga03.intel.com ([143.182.124.21]:42649 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751524AbaH0Hns (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 03:43:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,409,1406617200"; 
   d="scan'208";a="473074130"
Message-ID: <1409125313.8085.22.camel@rzhang1-toshiba>
Subject: Re: [GIT PULL] thermal soc changes
From: Zhang Rui <rui.zhang@intel.com>
To: Eduardo Valentin <edubezval@gmail.com>
Cc: Linux PM <linux-pm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Date: Wed, 27 Aug 2014 15:41:53 +0800
In-Reply-To: <1408711592-8917-1-git-send-email-edubezval@gmail.com>
References: <1408711592-8917-1-git-send-email-edubezval@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-08-22 at 08:46 -0400, Eduardo Valentin wrote:
> Hello Rui,
> 
> Please pull these changes. Here we have three new features: IMX driver has
> now support to i.mx6sx, the of-thermal now if aware of disabled thermal zones
> in DT, and we shall have tracing support on thermal framework.
> 
> The following changes since commit 47d104ba5879790c7c91c3390b0b08399e168efe:
> 
>   Merge branches 'exynos-fix', 'for-rc', 'int3403-fix', 'misc', 'rcar-thermal' and 'sti-thermal' of .git into next (2014-07-22 10:13:00 +0800)
> 
> are available in the git repository at:
> 
> 
>   https://git.kernel.org/pub/scm/linux/kernel/git/rzhang/linux.git 
> 

I suppose you mean
http://git.kernel.org/pub/scm/linux/kernel/git/evalenti/linux-soc-thermal.git next branch. And I've pulled those changes in your next branch.

thanks,
rui
> for you to fetch changes up to 3c94f17e72a7bcf689756da100b6051e535c45f4:
> 
>   Thermal: imx: add i.mx6sx thermal support (2014-08-09 10:29:30 -0400)
> 
> ----------------------------------------------------------------
> Anson Huang (1):
>       Thermal: imx: add i.mx6sx thermal support
> 
> Laxman Dewangan (1):
>       thermal: add support to disable thermal zone from DTS
> 
> Punit Agrawal (3):
>       thermal: trace: Trace temperature changes
>       thermal: trace: Trace when a cooling device's state is updated
>       thermal: trace: Trace when temperature is above a trip point
> 
>  .../devicetree/bindings/thermal/imx-thermal.txt    |  5 +-
>  drivers/thermal/fair_share.c                       | 12 +++
>  drivers/thermal/imx_thermal.c                      | 91 ++++++++++++++++++----
>  drivers/thermal/of-thermal.c                       | 12 +++
>  drivers/thermal/step_wise.c                        |  5 +-
>  drivers/thermal/thermal_core.c                     |  7 ++
>  include/trace/events/thermal.h                     | 83 ++++++++++++++++++++
>  7 files changed, 200 insertions(+), 15 deletions(-)
>  create mode 100644 include/trace/events/thermal.h
> 
> 
>  BR,
> 
>  Eduardo Valentin


