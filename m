Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751761Ab3HTBkq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 21:40:46 -0400
Received: from mga03.intel.com ([143.182.124.21]:48819 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751364Ab3HTBkp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 21:40:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,915,1367996400"; 
   d="scan'208";a="284107495"
Date: Tue, 20 Aug 2013 03:40:42 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Chao Xie <chao.xie@marvell.com>
Cc: lee.jones@linaro.org, linux-kernel@vger.kernel.org, xiechao.mail@gmail.com
Subject: Re: [PATCH 1/2] mfd: 88pm800: Fix the bug that pdata may be NULL
Message-ID: <20130820014042.GF13324@zurbaran>
References: <1376875675-11286-1-git-send-email-chao.xie@marvell.com>
 <1376875675-11286-2-git-send-email-chao.xie@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376875675-11286-2-git-send-email-chao.xie@marvell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Xie,

On Sun, Aug 18, 2013 at 09:27:54PM -0400, Chao Xie wrote:
> User pass platform data to device, and platform data may be
> NULL. 
In which case do you get that ? With DT ? 
Should rtc_init fail when pdata is NULL ?

You need to explain that, be it only for us to know if it's a critical
fix or not.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
