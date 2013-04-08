Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964920Ab3DHP0O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 11:26:14 -0400
Received: from mga09.intel.com ([134.134.136.24]:21650 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936123Ab3DHP0N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 11:26:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,432,1363158000"; 
   d="scan'208";a="291780046"
Date: Mon, 8 Apr 2013 17:26:11 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Jingoo Han <jg1.han@samsung.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 1/9] mfd: 88pm860x: drop devm_kfree of devm_kzalloc'd
 data
Message-ID: <20130408152611.GV24058@zurbaran>
References: <000f01ce0f4c$7c1d01d0$74570570$%han@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000f01ce0f4c$7c1d01d0$74570570$%han@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jingoo,

On Wed, Feb 20, 2013 at 06:27:21PM +0900, Jingoo Han wrote:
> devm_kfree() allocates memory that is released when a driver detaches.
> Thus, there is no reason to explicitly call devm_kfree() in probe or remove
> functions.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
> No changes since v1:
> 
>  drivers/mfd/88pm860x-core.c |   12 +++---------
>  1 files changed, 3 insertions(+), 9 deletions(-)
All 9 patches applied to mfd-next, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
