Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755237Ab3EHLto (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 07:49:44 -0400
Received: from mga02.intel.com ([134.134.136.20]:8614 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754323Ab3EHLtm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 07:49:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,634,1363158000"; 
   d="scan'208";a="333692066"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Fabio Estevam <fabio.estevam@freescale.com>, shawn.guo@linaro.org
Cc: kernel@pengutronix.de, festevam@gmail.com,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/13] pwm: pwm-mxs: Let device core handle pinctrl
In-Reply-To: <1367863561-11534-6-git-send-email-fabio.estevam@freescale.com>
References: <1367863561-11534-1-git-send-email-fabio.estevam@freescale.com> <1367863561-11534-6-git-send-email-fabio.estevam@freescale.com>
User-Agent: Notmuch/0.12+187~ga2502b0 (http://notmuchmail.org) Emacs/23.4.1 (x86_64-pc-linux-gnu)
Date: Wed, 08 May 2013 14:51:33 +0300
Message-ID: <87d2t1n0ze.fsf@ashishki-desk.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fabio Estevam <fabio.estevam@freescale.com> writes:

> Since commit ab78029 (drivers/pinctrl: grab default handles from device core),
> we can rely on device core for handling pinctrl.
>
> So remove devm_pinctrl_get_select_default() from the driver. 
>
> Cc: Thierry Reding <thierry.reding@avionic-design.de>
> Cc: <linux-kernel@vger.kernel.org>
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
> ---
>  drivers/pwm/pwm-mxs.c |    6 ------
>  1 file changed, 6 deletions(-)

Looks good, can we have some tested-by from imx guys?

Regards,
--
Alex
