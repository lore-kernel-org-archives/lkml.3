Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757652Ab3FLBEl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 21:04:41 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:51012 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753649Ab3FLBEk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 21:04:40 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Peter De Schrijver <pdeschrijver@nvidia.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1370444796-18648-1-git-send-email-pdeschrijver@nvidia.com>
Cc: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
References: <1370444796-18648-1-git-send-email-pdeschrijver@nvidia.com>
Message-ID: <20130612010435.8816.19733@quantum>
User-Agent: alot/0.3.4
Subject: Re: [PATCH 0/2] Fix some uses of clk->rate
Date: Tue, 11 Jun 2013 18:04:35 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Peter De Schrijver (2013-06-05 08:06:34)
> Using clk->rate directly does not take the CLK_GET_RATE_NOCACHE flag into
> account. This can cause wrong results if the flag is set.
> 
> Peter De Schrijver (2):
>   clk: use clk_get_rate() for debugfs
>   clk: honor CLK_GET_RATE_NOCACHE in clk_set_rate
> 

Pulled into clk-next.

Thanks!
Mike

>  drivers/clk/clk.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> -- 
> 1.7.7.rc0.72.g4b5ea.dirty
