Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756050Ab3FKSUB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 14:20:01 -0400
Received: from mga14.intel.com ([143.182.124.37]:30775 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753238Ab3FKSUA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 14:20:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,846,1363158000"; 
   d="scan'208";a="253606073"
Date: Tue, 11 Jun 2013 20:19:34 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/16] mfd: tps65912: Convert to managed resources for
 allocating memory
Message-ID: <20130611181934.GM29135@zurbaran>
References: <1369322717-30429-1-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369322717-30429-1-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

On Thu, May 23, 2013 at 04:25:02PM +0100, Lee Jones wrote:
> Saves on code and simplifies the driver, as these resources are now
> tracked and freed automatically when the driver is realised.
> 
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/mfd/tps65912-core.c |    2 --
>  drivers/mfd/tps65912-i2c.c  |    3 ++-
>  drivers/mfd/tps65912-spi.c  |    3 ++-
>  3 files changed, 4 insertions(+), 4 deletions(-)
All 16 patches applied to mfd-next, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
