Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209AbaIAQNU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 12:13:20 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:45420 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753963AbaIAQNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 12:13:18 -0400
Message-ID: <54049B1A.70905@cogentembedded.com>
Date: Mon, 01 Sep 2014 20:13:14 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        "David S. Miller" <davem@davemloft.net>
CC: Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>, netdev@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: sh_eth: fix driver dependencies
References: <1749721.1a6rN6K2Gg@amdc1032>
In-Reply-To: <1749721.1a6rN6K2Gg@amdc1032>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/01/2014 06:25 PM, Bartlomiej Zolnierkiewicz wrote:

> Renesas SuperH Ethernet support should be available only on
> Renesas ARM SoCs and SuperH architecture.

> Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Simon Horman <horms@verge.net.au>
> Cc: Magnus Damm <magnus.damm@gmail.com>

Acked-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>

WBR, Sergei

