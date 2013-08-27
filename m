Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238Ab3H0I3L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 04:29:11 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:34422 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752194Ab3H0I3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 04:29:09 -0400
Date: Tue, 27 Aug 2013 09:29:04 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, linus.walleij@linaro.org,
        sameo@linux.intel.com
Subject: Re: [PATCH 1/1] mfd: ab8500-debugfs: Staticize local variables
Message-ID: <20130827082904.GB7136@lee--X1>
References: <1377259662-17401-1-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1377259662-17401-1-git-send-email-sachin.kamat@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Aug 2013, Sachin Kamat wrote:

> Local variables referenced only in this file are made static.
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> ---
>  drivers/mfd/ab8500-debugfs.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)

Applied with Linus' Ack.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
