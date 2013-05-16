Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856Ab3EPWPn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 18:15:43 -0400
Received: from mga14.intel.com ([143.182.124.37]:54108 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753614Ab3EPWPl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 18:15:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,686,1363158000"; 
   d="scan'208";a="303636685"
Date: Fri, 17 May 2013 00:15:19 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Olof Johansson <olof@lixom.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: max77687: add registration of max77686-clk
Message-ID: <20130516221519.GK22822@zurbaran>
References: <1368205919-32538-1-git-send-email-olof@lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368205919-32538-1-git-send-email-olof@lixom.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Olof,

On Fri, May 10, 2013 at 10:11:59AM -0700, Olof Johansson wrote:
> The MAX77686 clock driver has been in-tree for over 6 months, but never
> actually enabled through the MFD registration before.
> 
> Add it to the table so the device will probe and configure properly.
> 
> Signed-off-by: Olof Johansson <olof@lixom.net>
> ---
>  drivers/mfd/max77686.c | 1 +
>  1 file changed, 1 insertion(+)
Applied to mfd-next, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
