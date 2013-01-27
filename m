Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756931Ab3A0Xwo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 18:52:44 -0500
Received: from mga02.intel.com ([134.134.136.20]:2886 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754326Ab3A0Xwk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 18:52:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,547,1355126400"; 
   d="scan'208";a="253318870"
Date: Mon, 28 Jan 2013 00:52:39 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com,
        Jonas Aaberg <jonas.aberg@stericsson.com>
Subject: Re: [PATCH 05/26] mfd: ab8500-gpadc: Change to mdelay for greater
 resolution
Message-ID: <20130127235239.GM1174@sortiz-mobl>
References: <1358254566-12419-1-git-send-email-lee.jones@linaro.org>
 <1358254566-12419-6-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358254566-12419-6-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee, Jonas,

On Tue, Jan 15, 2013 at 12:55:45PM +0000, Lee Jones wrote:
> From: Jonas Aaberg <jonas.aberg@stericsson.com>
> 
> The resolution of msleep is related to HZ, so with HZ set to
> 100 any msleep of less than 10ms will become ~10ms.
usleep_range would be more appropriate, sleeping should be preferred over
spinning.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
