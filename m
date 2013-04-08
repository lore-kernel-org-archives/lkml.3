Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935355Ab3DHJrv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 05:47:51 -0400
Received: from mga11.intel.com ([192.55.52.93]:55048 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934937Ab3DHJru (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 05:47:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,429,1363158000"; 
   d="scan'208";a="315802947"
Date: Mon, 8 Apr 2013 11:47:47 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, patches@linaro.org,
        Jonghwa Lee <jonghwa3.lee@samsung.com>
Subject: Re: [PATCH 1/1] mfd: max77686: Use NULL instead of 0
Message-ID: <20130408094747.GO24058@zurbaran>
References: <1364273016-18270-1-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364273016-18270-1-git-send-email-sachin.kamat@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sachin,

On Tue, Mar 26, 2013 at 10:13:36AM +0530, Sachin Kamat wrote:
> 'data' is a pointer and hence use NULL instead of 0.
> Silences the following warning:
> drivers/mfd/max77686.c:49:50: warning: Using plain integer as NULL pointer
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> Cc: Jonghwa Lee <jonghwa3.lee@samsung.com>
> ---
>  drivers/mfd/max77686.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
Patch applied to mfd-next, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
