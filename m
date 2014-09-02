Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086AbaIBLz1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 07:55:27 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:44339 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753423AbaIBLzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 07:55:23 -0400
Date: Tue, 2 Sep 2014 12:55:18 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>
Subject: Re: [PATCH v2 4/4] mfd: lpc_sch: remove FSF address
Message-ID: <20140902115518.GJ17117@lee--X1>
References: <1409654722-6570-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <1409654722-6570-5-git-send-email-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1409654722-6570-5-git-send-email-andriy.shevchenko@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 02 Sep 2014, Andy Shevchenko wrote:

> This patch removes FSF address because it can be changed. While here, update
> the copyright lines by adding Intel Corp. to them.
> 
> There is no functional change.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  drivers/mfd/lpc_sch.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)

Applied, thanks.

> diff --git a/drivers/mfd/lpc_sch.c b/drivers/mfd/lpc_sch.c
> index ae614b2..c980da4 100644
> --- a/drivers/mfd/lpc_sch.c
> +++ b/drivers/mfd/lpc_sch.c
> @@ -7,6 +7,7 @@
>   *  Configuration Registers.
>   *
>   *  Copyright (c) 2010 CompuLab Ltd
> + *  Copyright (c) 2014 Intel Corp.
>   *  Author: Denis Turischev <denis@compulab.co.il>
>   *
>   *  This program is free software; you can redistribute it and/or modify
> @@ -17,10 +18,6 @@
>   *  but WITHOUT ANY WARRANTY; without even the implied warranty of
>   *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>   *  GNU General Public License for more details.
> - *
> - *  You should have received a copy of the GNU General Public License
> - *  along with this program; see the file COPYING.  If not, write to
> - *  the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
>   */
>  
>  #include <linux/kernel.h>

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
