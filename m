Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964905Ab3GLNti (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 09:49:38 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:36987 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964861Ab3GLNth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 09:49:37 -0400
Date: Fri, 12 Jul 2013 14:49:31 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] MFD: twl6040: Remove support for legacy (pdata) mode
Message-ID: <20130712134931.GL25601@gmail.com>
References: <1373628724-11397-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1373628724-11397-1-git-send-email-peter.ujfalusi@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Jul 2013, Peter Ujfalusi wrote:

> TWL6040 is used only with OMAP4/5 SoCs and they can only boot in in DT mode.
> The support for pdata/legacy boot can be removed.
> 
> Add TODO comment to the header file that all pdata struct can be removed in
> the next merge window (after the sub driver updates are in).
> 
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
> ---
>  drivers/mfd/twl6040.c       | 55 +++++++++++----------------------------------
>  include/linux/mfd/twl6040.h |  1 +
>  2 files changed, 14 insertions(+), 42 deletions(-)

Applied, thanks.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
