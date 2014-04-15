Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754252AbaDOKEH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 06:04:07 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:53785 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924AbaDOKEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 06:04:00 -0400
Date: Tue, 15 Apr 2014 11:03:54 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Matt Porter <mporter@linaro.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mfd: bcm590xx: Add missing remove function
Message-ID: <20140415100354.GB27091@lee--X1>
References: <1396272676.7843.1.camel@phoenix>
 <1396272757.7843.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1396272757.7843.2.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Add missing mfd_remove_devices() call in remove function.
> 
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
>  drivers/mfd/bcm590xx.c | 7 +++++++
>  1 file changed, 7 insertions(+)

Applied, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
