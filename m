Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751346Ab3LKJ1d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 04:27:33 -0500
Received: from mail-yh0-f54.google.com ([209.85.213.54]:43668 "EHLO
	mail-yh0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823Ab3LKJ13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 04:27:29 -0500
Date: Wed, 11 Dec 2013 09:27:24 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/8] mfd: ssbi: Remove platform data structs and hide
 ssbi type enum
Message-ID: <20131211092724.GD16780@lee--X1>
References: <1386718523-2587-1-git-send-email-sboyd@codeaurora.org>
 <1386718523-2587-2-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1386718523-2587-2-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Dec 2013, Stephen Boyd wrote:

> The ssbi driver assumes that the device is DT based. Remove the
> platform data structs that will never be used and hide the enum
> in the only C file that uses it.
> 
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
>  drivers/mfd/ssbi.c   |  6 ++++++
>  include/linux/ssbi.h | 17 +----------------
>  2 files changed, 7 insertions(+), 16 deletions(-)

I don't see any uses of the aforementioned struct.

Patch applied, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
