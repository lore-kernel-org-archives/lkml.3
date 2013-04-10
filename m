Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935483Ab3DJWRf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 18:17:35 -0400
Received: from mga03.intel.com ([143.182.124.21]:48701 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750919Ab3DJWRd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 18:17:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,450,1363158000"; 
   d="scan'208";a="225733625"
Date: Thu, 11 Apr 2013 00:17:21 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Rhyland Klein <rklein@nvidia.com>
Cc: linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH] mfd: tps65090: Add compatible string for charger subnode
Message-ID: <20130410221721.GM4874@zurbaran>
References: <1365614095-5846-1-git-send-email-rklein@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365614095-5846-1-git-send-email-rklein@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rhyland,

On Wed, Apr 10, 2013 at 01:14:55PM -0400, Rhyland Klein wrote:
> This patch adds the of_compatible value for the tps65090 charger
> subnode used when loading the driver to find its properties
> and of_node.
> 
> Signed-off-by: Rhyland Klein <rklein@nvidia.com>
> ---
>  drivers/mfd/tps65090.c |    1 +
>  1 file changed, 1 insertion(+)
Applied, thanks. And sorry for taking the wrong version.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
