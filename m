Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753178Ab3H0I2Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 04:28:24 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:53787 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055Ab3H0I2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 04:28:22 -0400
Date: Tue, 27 Aug 2013 09:28:17 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, sameo@linux.intel.com,
        linus.walleij@linaro.org
Subject: Re: [PATCH 2/2] mfd: db8500-prcmu: Staticize clk_mgt
Message-ID: <20130827082817.GA7136@lee--X1>
References: <1377257720-15861-1-git-send-email-sachin.kamat@linaro.org>
 <1377257720-15861-2-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1377257720-15861-2-git-send-email-sachin.kamat@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Aug 2013, Sachin Kamat wrote:

> clk_mgt is used only in this file. Make it static.
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> ---
>  drivers/mfd/db8500-prcmu.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

Applied with Linus' Ack.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
