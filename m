Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965115Ab3FTIyY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 04:54:24 -0400
Received: from mga01.intel.com ([192.55.52.88]:60842 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935296Ab3FTIyV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 04:54:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,903,1363158000"; 
   d="scan'208";a="356614653"
Date: Thu, 20 Jun 2013 10:54:16 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Seth Heasley <seth.heasley@intel.com>
Cc: Peter Tyser <ptyser@xes-inc.com>, linux-kernel@vger.kernel.org,
        James Ralston <james.d.ralston@intel.com>
Subject: Re: [PATCH 4/4] lpc_ich: iTCO_wdt patch for Intel Coleto Creek
 DeviceIDs
Message-ID: <20130620085416.GE15667@zurbaran>
References: <1371686665-6622-1-git-send-email-seth.heasley@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371686665-6622-1-git-send-email-seth.heasley@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Seth,

On Wed, Jun 19, 2013 at 05:04:25PM -0700, Seth Heasley wrote:
> This patch adds the LPC Controller DeviceIDs for iTCO Watchdog for the Intel Coleto Creek PCH.
> 
> Signed-off-by: Seth Heasley <seth.heasley@intel.com>
> ---
>  drivers/mfd/lpc_ich.c |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
This one did not apply on top of mfd-next, because of the Avoton SoC
addition.
I fixed it manually, but please verify that it's all right:

https://git.kernel.org/cgit/linux/kernel/git/sameo/mfd-next.git/commit/?id=283aae8ab88e695a660c610d6535ca44bc5b8835

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
