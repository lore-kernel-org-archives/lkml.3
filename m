Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932208Ab3GPL0v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 07:26:51 -0400
Received: from ns.mm-sol.com ([212.124.72.66]:43921 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932075Ab3GPL0u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 07:26:50 -0400
Message-ID: <1373973956.2657.4.camel@iivanov-dev>
Subject: Re: [PATCH v2 0/7] usb: phy: msm: Fixes and cleanups
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: balbi@ti.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Date: Tue, 16 Jul 2013 14:25:56 +0300
In-Reply-To: <1373384833-18077-1-git-send-email-iivanov@mm-sol.com>
References: <1373384833-18077-1-git-send-email-iivanov@mm-sol.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Felipe, 

On Tue, 2013-07-09 at 18:47 +0300, Ivan T. Ivanov wrote:
> From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
> 
> Changes since first version.
> * Extend commit messages a little bit.
> 
> Following patches make initial cleanup of usb phy found in the Qualcomm
> chipsets. Changes include:
> * Build time error fix.
> * Move driver to Managed Device Resource allocation.
> * Checkpatch warnings and error fixes
> * Removed usage of global regulators variables.
> 
> Ivan T. Ivanov (7):
>   usb: phy: msm: Move mach depndend code to platform data
>   usb: phy: msm: Migrate to Managed Device Resource allocation
>   usb: phy: msm: Move regulator usage to managed resource allocation
>   usb: phy: msm: Remove unnecessarily check for valid regulators.
>   usb: phy: msm: Fix WARNING: quoted string split across lines
>   usb: phy: msm: Fix WARNING: Prefer seq_puts to seq_printf
>   usb: phy: msm: Lindent the code


Could you take a look at these patches, please.
I would like to clean up this driver and add support for
controllers which can be found in new MSM8974 chipsets.

If there is something, which you would like to see improved
in this driver, please let me know.

Regards,
Ivan

> 
>  arch/arm/mach-msm/board-msm7x30.c |   35 ++++
>  arch/arm/mach-msm/board-qsd8x50.c |   34 ++++
>  drivers/usb/phy/phy-msm-usb.c     |  384 ++++++++++++++-----------------------
>  include/linux/usb/msm_hsusb.h     |    5 +
>  4 files changed, 220 insertions(+), 238 deletions(-)
> 


