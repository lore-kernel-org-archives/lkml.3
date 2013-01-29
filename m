Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755995Ab3A2LqI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 06:46:08 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:50810 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752969Ab3A2LqC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 06:46:02 -0500
Message-ID: <5107B650.5090901@ti.com>
Date: Tue, 29 Jan 2013 17:15:20 +0530
From: Mugunthan V N <mugunthanvnm@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Pantelis Antoniou <panto@antoniou-consulting.com>
CC: Richard Cochran <richardcochran@gmail.com>, Matt Porter <mporter@ti.com>,
        Chase Maupin <chase.maupin@ti.com>, Jason Kridner <jdk@ti.com>,
        Tony Lindgren <tony@atomide.com>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cpsw: Fix interrupt storm among other things
References: <1359378668-26536-1-git-send-email-panto@antoniou-consulting.com>
In-Reply-To: <1359378668-26536-1-git-send-email-panto@antoniou-consulting.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/28/2013 6:41 PM, Pantelis Antoniou wrote:
> Fix interrupt storm on bone A4 cause by non-by-the-book interrupt handling.
> While at it, added a non-NAPI mode (which is easier to debug), plus
> some general fixes.
>
> Signed-off-by: Pantelis Antoniou <panto@antoniou-consulting.com>
> ---
>   Documentation/devicetree/bindings/net/cpsw.txt |   1 +
>   drivers/net/ethernet/ti/cpsw.c                 | 222 +++++++++++++++++++++----
>   drivers/net/ethernet/ti/davinci_cpdma.c        |   4 +-
>   drivers/net/ethernet/ti/davinci_cpdma.h        |   2 +-
>   include/linux/platform_data/cpsw.h             |   1 +
>   5 files changed, 194 insertions(+), 36 deletions(-)
I have tested CPSW on AM335x EVM 1.5A with flood ping and i am not
seeing any interrupt storm.
Can you provide more details on how to reproduce the issue.

Regards
Mugunthan V N
