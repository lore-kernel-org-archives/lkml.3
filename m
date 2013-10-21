Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751937Ab3JURvJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 13:51:09 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:38941 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751450Ab3JURvH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 13:51:07 -0400
Message-ID: <52656971.3020509@ti.com>
Date: Mon, 21 Oct 2013 23:20:41 +0530
From: Mugunthan V N <mugunthanvnm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Mariusz Ceier <mceier+kernel@gmail.com>
CC: "David S. Miller" <davem@davemloft.net>,
        Lad Prabhakar <prabhakar.csengg@gmail.com>,
        Jingoo Han <jg1.han@samsung.com>, Jiri Pirko <jiri@resnulli.us>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] davinci_emac.c: Fix IFF_ALLMULTI setup
References: <5265640C.4070201@cogentembedded.com> <1382377504-24688-1-git-send-email-mceier+kernel@gmail.com>
In-Reply-To: <1382377504-24688-1-git-send-email-mceier+kernel@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 21 October 2013 11:15 PM, Mariusz Ceier wrote:
> When IFF_ALLMULTI flag is set on interface and IFF_PROMISC isn't,
> emac_dev_mcast_set should only enable RX of multicasts and reset
> MACHASH registers.
>
> It does this, but afterwards it either sets up multicast MACs
> filtering or disables RX of multicasts and resets MACHASH registers
> again, rendering IFF_ALLMULTI flag useless.
>
> This patch fixes emac_dev_mcast_set, so that multicast MACs filtering and
> disabling of RX of multicasts are skipped when IFF_ALLMULTI flag is set.
>
> Tested with kernel 2.6.37.
>
> Signed-off-by: Mariusz Ceier <mceier+kernel@gmail.com>
> ---
Can you add [PATCH v2] in your subject in future so that it will be
easier to the maintainer to pick the latest version of the patch.

Acked-by: Mugunthan V N <mugunthanvnm@ti.com>

Regards
Mugunthan V N
