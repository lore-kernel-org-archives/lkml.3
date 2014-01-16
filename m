Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752085AbaAPGPG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 01:15:06 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:42742 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379AbaAPGPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 01:15:03 -0500
Message-ID: <52D778DC.8020607@ti.com>
Date: Thu, 16 Jan 2014 11:44:52 +0530
From: Mugunthan V N <mugunthanvnm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Prabhakar Lad <prabhakar.csengg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: davinci_mdio: Fix sparse warning
References: <1389852341-15393-1-git-send-email-prabhakar.csengg@gmail.com>
In-Reply-To: <1389852341-15393-1-git-send-email-prabhakar.csengg@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 16 January 2014 11:35 AM, Prabhakar Lad wrote:
> From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
>
> This patch fixes following sparse warning
> davinci_mdio.c:85:27: warning: symbol 'default_pdata' was not declared. Should it be static?
> Also makes the default_pdata as a constant.
>
> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
Acked-by: Mugunthan V N <mugunthanvnm@ti.com>

Regards
Mugunthan V N
