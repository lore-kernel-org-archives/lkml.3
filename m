Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754274Ab3CUX40 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 19:56:26 -0400
Received: from mga01.intel.com ([192.55.52.88]:2253 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754091Ab3CUX4Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 19:56:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,888,1355126400"; 
   d="scan'208";a="306656810"
Date: Fri, 22 Mar 2013 00:55:34 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: David Rientjes <rientjes@google.com>
Cc: Simon Glass <sjg@chromium.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch] drivers, mfd: fix link error
Message-ID: <20130321235534.GA22862@zurbaran>
References: <alpine.DEB.2.02.1303211206160.5662@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1303211206160.5662@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Thu, Mar 21, 2013 at 12:08:33PM -0700, David Rientjes wrote:
> CONFIG_MFD_CROS_EC requires CONFIG_MFD_CORE for a couple of functions that 
> are declared but not defined:
> 
> 	ERROR: "mfd_remove_devices" [drivers/mfd/cros_ec.ko] undefined!
> 	ERROR: "mfd_add_devices" [drivers/mfd/cros_ec.ko] undefined!
> 
> Fix it by selecting CONFIG_MFD_CORE anytime CONFIG_MFD_CROS_EC is enabled.
> 
> Signed-off-by: David Rientjes <rientjes@google.com>
> ---
>  drivers/mfd/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
Patch applied, many thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
