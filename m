Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757030Ab3A0Xxn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 18:53:43 -0500
Received: from mga03.intel.com ([143.182.124.21]:39200 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756956Ab3A0Xxk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 18:53:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,547,1355126400"; 
   d="scan'208";a="249000494"
Date: Mon, 28 Jan 2013 00:53:39 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com,
        Jonas Aaberg <jonas.aberg@stericsson.com>
Subject: Re: [PATCH 25/26] mfd: ab8500-gpadc: Reduce conversion timeout
Message-ID: <20130127235339.GS1174@sortiz-mobl>
References: <1358254566-12419-1-git-send-email-lee.jones@linaro.org>
 <1358254566-12419-26-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358254566-12419-26-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

On Tue, Jan 15, 2013 at 12:56:05PM +0000, Lee Jones wrote:
> @@ -598,8 +601,6 @@ static int ab8500_gpadc_runtime_resume(struct device *dev)
>  
>  static int ab8500_gpadc_runtime_idle(struct device *dev)
>  {
> -	struct ab8500_gpadc *gpadc = dev_get_drvdata(dev);
> -
Unrelated change, please remove that part.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
