Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965491AbaGPRtx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 13:49:53 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:55002 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759822AbaGPRtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 13:49:50 -0400
X-CheckPoint: {53C6BB3D-1-2100090A-C0000000}
Message-ID: <53C6BB3D.5010605@tilera.com>
Date: Wed, 16 Jul 2014 13:49:49 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Tom Gundersen <teg@jklm.no>, <netdev@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, David Miller <davem@davemloft.net>,
        David Herrmann <dh.herrmann@gmail.com>, Kay Sievers <kay@vrfy.org>
Subject: Re: [PATCH v7 27/33] net: tile - set name assign type
References: <1404980258-30853-1-git-send-email-teg@jklm.no> <1404980258-30853-28-git-send-email-teg@jklm.no>
In-Reply-To: <1404980258-30853-28-git-send-email-teg@jklm.no>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.9.0.23]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/10/2014 4:23 AM, Tom Gundersen wrote:
> The name is obtained from the 'hardware', so consider it predictable.
>
> Signed-off-by: Tom Gundersen<teg@jklm.no>
> Cc: Chris Metcalf<cmetcalf@tilera.com>
> ---
>   drivers/net/ethernet/tile/tilegx.c  |  7 ++++---
>   drivers/net/ethernet/tile/tilepro.c | 13 +++++++------
>   2 files changed, 11 insertions(+), 9 deletions(-)

Acked-by: Chris Metcalf <cmetcalf@tilera.com>

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

