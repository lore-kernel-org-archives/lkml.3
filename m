Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754315Ab3EPWPt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 18:15:49 -0400
Received: from mga14.intel.com ([143.182.124.37]:19209 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753614Ab3EPWPs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 18:15:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,686,1363158000"; 
   d="scan'208";a="303636831"
Date: Fri, 17 May 2013 00:15:40 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Andrey Smirnov <andrew.smirnov@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: si476x: Use get_unaligned_be16() for unaligned be16
 loads
Message-ID: <20130516221540.GM22822@zurbaran>
References: <1368100865-16025-1-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368100865-16025-1-git-send-email-geert@linux-m68k.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert,

On Thu, May 09, 2013 at 02:01:05PM +0200, Geert Uytterhoeven wrote:
> Loading be16 values from byte buffers may cause unaligned accesses, so use
> get_unaligned_be16() to avoid problems on architectures that do not support
> these.
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---
>  drivers/mfd/si476x-cmd.c |   28 +++++++++++++++-------------
>  1 files changed, 15 insertions(+), 13 deletions(-)
Applied to mfd-fixes, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
