Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753763AbaICCi5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 22:38:57 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:34960 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871AbaICCi4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 22:38:56 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Soren Brinkmann <soren.brinkmann@xilinx.com>,
        "Michal Simek" <michal.simek@xilinx.com>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1409698929-30143-1-git-send-email-soren.brinkmann@xilinx.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        "Soren Brinkmann" <soren.brinkmann@xilinx.com>
References: <1409698929-30143-1-git-send-email-soren.brinkmann@xilinx.com>
Message-ID: <20140903023844.5251.5476@quantum>
User-Agent: alot/0.3.5
Subject: Re: [PATCH 0/3] clk: zynq: Clean up
Date: Tue, 02 Sep 2014 19:38:44 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Soren Brinkmann (2014-09-02 16:02:06)
> Hi,
> 
> triggered by that discussion whether checkpatch should be used to check
> files, I ran checkpatch on Zynq's clock code. A few of the reported
> issues I found worth fixing.

Applied to clk-next.

Regards,
Mike

> 
>         Thanks,
>         Sören
> 
> Soren Brinkmann (3):
>   clk: zynq: Remove unnecessary OOM message
>   clk: zynq: Remove pointless return at end of void function
>   clk: zynq: Move const initdata into correct code section
> 
>  drivers/clk/zynq/clkc.c | 30 ++++++++++++++----------------
>  drivers/clk/zynq/pll.c  |  4 +---
>  2 files changed, 15 insertions(+), 19 deletions(-)
> 
> -- 
> 2.1.0.1.g27b9230
> 
