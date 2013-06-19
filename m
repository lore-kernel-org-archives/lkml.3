Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756743Ab3FSIZE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 04:25:04 -0400
Received: from mga14.intel.com ([143.182.124.37]:3531 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756536Ab3FSIZA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 04:25:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,895,1363158000"; 
   d="scan'208";a="257108579"
Date: Wed, 19 Jun 2013 10:24:57 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chao Xie <chao.xie@marvell.com>, Yi Zhang <yizhang@marvell.com>
Subject: Re: linux-next: build failure after merge of the final tree (mfd
 tree related)
Message-ID: <20130619082456.GR7161@zurbaran>
References: <20130618171957.9d8fbcf376243d1d5f1d92b0@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130618171957.9d8fbcf376243d1d5f1d92b0@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Tue, Jun 18, 2013 at 05:19:57PM +1000, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the final tree, today's linux-next build (powerpc
> allyesconfig) failed like this:
> 
> drivers/mfd/88pm800.c: In function 'pm800_pages_init':
> drivers/mfd/88pm800.c:434:2: error: implicit declaration of function 'IS_ERR' [-Werror=implicit-function-declaration]
>   if (IS_ERR(subchip->regmap_power)) {
>   ^
> drivers/mfd/88pm800.c:435:3: error: implicit declaration of function 'PTR_ERR' [-Werror=implicit-function-declaration]
>    ret = PTR_ERR(subchip->regmap_power);
>    ^
> 
> Caused by commit f8ca616f67f7 ("mfd: 88pm800: Enhance error handling for
> sub pages probe/remove") from the mfd tree.  Forgot to include
> linux/err.h (see Rule 1 in Documentation/SubmitChecklist).
Sorry about that. This is fixed now.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
