Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755462Ab3HWKjf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 06:39:35 -0400
Received: from mail-ea0-f170.google.com ([209.85.215.170]:34701 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755348Ab3HWKje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 06:39:34 -0400
Date: Fri, 23 Aug 2013 11:39:25 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, sameo@linux.intel.com
Subject: Re: [PATCH 1/3] mfd: timberdale: Staticize local variables
Message-ID: <20130823103925.GE17154@lee--X1>
References: <1377252665-7152-1-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1377252665-7152-1-git-send-email-sachin.kamat@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Aug 2013, Sachin Kamat wrote:

> Local variables referenced only in this file are made static.
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> ---
>  drivers/mfd/timberdale.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)

All three patches applied, thanks.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
