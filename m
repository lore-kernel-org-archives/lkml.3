Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751871Ab3LCIMI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 03:12:08 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:49755 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067Ab3LCIME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 03:12:04 -0500
Date: Tue, 3 Dec 2013 08:11:57 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, "'Samuel Ortiz'" <sameo@linux.intel.com>
Subject: Re: [PATCH 16/39] mfd: remove DEFINE_PCI_DEVICE_TABLE macro
Message-ID: <20131203081157.GJ31626@lee--X1>
References: <001501ceefb1$69c96820$3d5c3860$%han@samsung.com>
 <002501ceefb4$6a4e2120$3eea6360$%han@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <002501ceefb4$6a4e2120$3eea6360$%han@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 03 Dec 2013, Jingoo Han wrote:

> Don't use DEFINE_PCI_DEVICE_TABLE macro, because this macro
> is not preferred.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
>  drivers/mfd/cs5535-mfd.c          |    2 +-
>  drivers/mfd/janz-cmodio.c         |    2 +-
>  drivers/mfd/lpc_ich.c             |    2 +-
>  drivers/mfd/lpc_sch.c             |    2 +-
>  drivers/mfd/rdc321x-southbridge.c |    2 +-
>  drivers/mfd/rtsx_pcr.c            |    2 +-
>  drivers/mfd/sm501.c               |    2 +-
>  drivers/mfd/sta2x11-mfd.c         |    2 +-
>  drivers/mfd/timberdale.c          |    2 +-
>  drivers/mfd/vx855.c               |    2 +-
>  10 files changed, 10 insertions(+), 10 deletions(-)

Patch looks good to me, so unless The List cries blue murder I've
tentatively applied it.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
