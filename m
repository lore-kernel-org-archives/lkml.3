Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751987Ab3LLIL2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 03:11:28 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:44561 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751382Ab3LLILX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 03:11:23 -0500
Message-ID: <52A96F9F.7060801@ti.com>
Date: Thu, 12 Dec 2013 13:41:11 +0530
From: Mugunthan V N <mugunthanvnm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Felipe Balbi <balbi@ti.com>
CC: <davem@davemloft.net>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>
Subject: Re: [PATCH 1/2] drivers: net: cpsw: fix dt probe for one port ethernet
References: <1386821345-30555-1-git-send-email-balbi@ti.com>
In-Reply-To: <1386821345-30555-1-git-send-email-balbi@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Balbi

On Thursday 12 December 2013 09:39 AM, Felipe Balbi wrote:
> From: Mugunthan V N <mugunthanvnm@ti.com>
>
> When only one port of the two port is pinned out, then dt probe is failing
> because second port phy is not found. fixing this by checking the number of
> slaves and breaking the loop.
>
> Signed-off-by: Mugunthan V N <mugunthanvnm@ti.com>
> Signed-off-by: Felipe Balbi <balbi@ti.com>

This patch is already applied to net branch and its commit id is
3a27bfac17fe375539c4e0a53478679645eb5ae2.

Regards
Mugunthan V N
