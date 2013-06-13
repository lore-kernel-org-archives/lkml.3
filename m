Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932683Ab3FMKtv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 06:49:51 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:49407 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755945Ab3FMKtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 06:49:50 -0400
Date: Thu, 13 Jun 2013 11:49:43 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, sameo@linux.intel.com,
        Miguel Aguilar <miguel.aguilar@ridgerun.com>
Subject: Re: [PATCH Resend 1/1] mfd: davinci_voicecodec: Convert to use
 devm_* APIs
Message-ID: <20130613104943.GD16677@laptop>
References: <1371025182-31386-1-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1371025182-31386-1-git-send-email-sachin.kamat@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Jun 2013, Sachin Kamat wrote:

> devm_* APIs are device managed and make code simpler.
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> Cc: Miguel Aguilar <miguel.aguilar@ridgerun.com>
> ---
> CC'd Lee Jones

Can you resubmit this based on -rc5 please?

There have been some related changes since you wrote this patch.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
