Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754996Ab3EPWQI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 18:16:08 -0400
Received: from mga14.intel.com ([143.182.124.37]:27440 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754929Ab3EPWQG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 18:16:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,686,1363158000"; 
   d="scan'208";a="335354865"
Date: Fri, 17 May 2013 00:16:03 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Andrey Smirnov <andrew.smirnov@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mfd: si476x: Do not use binary constants
Message-ID: <20130516221603.GO22822@zurbaran>
References: <1368044622-25645-1-git-send-email-geert@linux-m68k.org>
 <1368044622-25645-2-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368044622-25645-2-git-send-email-geert@linux-m68k.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert,

On Wed, May 08, 2013 at 10:23:42PM +0200, Geert Uytterhoeven wrote:
> Gcc < 4.3 doesn't understand binary constanrs (0b*):
> 
> drivers/mfd/si476x-cmd.c:153:22: error: invalid suffix "b11111" on integer constant
> drivers/mfd/si476x-cmd.c:775:20: error: invalid suffix "b00001000" on integer constant
> drivers/mfd/si476x-cmd.c:776:20: error: invalid suffix "b00000100" on integer constant
> drivers/mfd/si476x-cmd.c:777:21: error: invalid suffix "b00000010" on integer constant
> drivers/mfd/si476x-cmd.c:778:21: error: invalid suffix "b00000001" on integer constant
> drivers/mfd/si476x-cmd.c:780:17: error: invalid suffix "b10000000" on integer constant
> drivers/mfd/si476x-cmd.c:781:22: error: invalid suffix "b00100000" on integer constant
> ...
> 
> Hence use hexadecimal constants (0x*) instead.
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> ---
>  drivers/mfd/si476x-cmd.c |  122 +++++++++++++++++++++++-----------------------
>  1 files changed, 61 insertions(+), 61 deletions(-)
Applied to mfd-fixes, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
