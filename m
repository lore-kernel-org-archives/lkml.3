Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754797Ab3EPWNq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 18:13:46 -0400
Received: from mga09.intel.com ([134.134.136.24]:22203 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752870Ab3EPWNo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 18:13:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,686,1363158000"; 
   d="scan'208";a="338561384"
Date: Fri, 17 May 2013 00:13:41 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: MFD_TPS65912 needs MFD_CORE
Message-ID: <20130516221341.GI22822@zurbaran>
References: <1366373156-24248-1-git-send-email-mmarek@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366373156-24248-1-git-send-email-mmarek@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marek,

On Fri, Apr 19, 2013 at 02:05:56PM +0200, Michal Marek wrote:
> With MFD_TPS65912=y and MFD_CORE=m/n, the build fails with
> 
> drivers/mfd/tps65912-core.c:147: undefined reference to `mfd_add_devices'
> drivers/mfd/tps65912-core.c:164: undefined reference to `mfd_remove_devices'
> drivers/mfd/tps65912-core.c:171: undefined reference to `mfd_remove_devices'
> 
> Signed-off-by: Michal Marek <mmarek@suse.cz>
> ---
>  drivers/mfd/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
This one is on my mfd-fixes tree already, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
