Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753417Ab3H0I1Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 04:27:25 -0400
Received: from mail-ea0-f173.google.com ([209.85.215.173]:62415 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753293Ab3H0I1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 04:27:23 -0400
Date: Tue, 27 Aug 2013 09:27:17 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, sameo@linux.intel.com,
        linus.walleij@linaro.org
Subject: Re: [PATCH 1/2] mfd: db8500-prcmu: Use ANSI function declaration
Message-ID: <20130827082717.GF6152@lee--X1>
References: <1377257720-15861-1-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1377257720-15861-1-git-send-email-sachin.kamat@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Aug 2013, Sachin Kamat wrote:

> Silences the following warning:
> drivers/mfd/db8500-prcmu.c:2322:25: warning:
> non-ANSI function declaration of function 'prcmu_ac_sleep_req'
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
