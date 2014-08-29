Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753616AbaH2O05 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 10:26:57 -0400
Received: from mail-qc0-f176.google.com ([209.85.216.176]:63834 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645AbaH2O0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 10:26:55 -0400
MIME-Version: 1.0
In-Reply-To: <1408705096-31286-6-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1408705096-31286-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <1408705096-31286-6-git-send-email-andriy.shevchenko@linux.intel.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 29 Aug 2014 08:26:35 -0600
Message-ID: <CAErSpo4K0O8142WSjTmq7zyFXDc2DDG7Ba8wReryT53XaHKZLw@mail.gmail.com>
Subject: Re: [PATCH v1 5/5] mfd: lpc_sch: remove FSF address
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Lee Jones <lee.jones@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 22, 2014 at 4:58 AM, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> This patch removes FSF address becase it can be changed. While here, update the

because

> copyright lines by adding Intel Corp. to them.
>
> There is no functional change.
>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  drivers/mfd/lpc_sch.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
>
> diff --git a/drivers/mfd/lpc_sch.c b/drivers/mfd/lpc_sch.c
> index 6145a4c..b14ca7c 100644
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
> --
> 2.1.0
>
