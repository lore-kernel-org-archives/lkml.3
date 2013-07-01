Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932081Ab3GAXA0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 19:00:26 -0400
Received: from mga14.intel.com ([143.182.124.37]:32485 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755100Ab3GAXAZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 19:00:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,976,1363158000"; 
   d="scan'208";a="358989094"
Date: Tue, 2 Jul 2013 00:55:17 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org, Mark Brown <broonie@linaro.org>
Subject: Re: [PATCH] mfd: wm8994: Remove duplicate check for active JACKDET
Message-ID: <20130701225517.GC4572@zurbaran>
References: <1372708578-9377-1-git-send-email-broonie@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372708578-9377-1-git-send-email-broonie@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Mon, Jul 01, 2013 at 08:56:18PM +0100, Mark Brown wrote:
> From: Mark Brown <broonie@linaro.org>
> 
> Probably the result of a mismerge or rebase failing to notice that the
> hunk had already been applied.
> 
> Signed-off-by: Mark Brown <broonie@linaro.org>
> ---
>  drivers/mfd/wm8994-core.c | 14 --------------
>  1 file changed, 14 deletions(-)
Applied to mfd-next, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
