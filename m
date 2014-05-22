Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752550AbaEVQDm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 12:03:42 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:64538 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932AbaEVQDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 12:03:40 -0400
Message-ID: <537E1FD8.8030504@6wind.com>
Date: Thu, 22 May 2014 18:03:36 +0200
From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Reply-To: nicolas.dichtel@6wind.com
Organization: 6WIND
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Horia Geanta <horia.geanta@freescale.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Lei Xu <Lei.Xu@freescale.com>, Sandeep Malik <Sandeep.Malik@freescale.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC ipsec-next] xfrm: make sha256 icv truncation length RFC-compliant
References: <1400771437-14096-1-git-send-email-horia.geanta@freescale.com> <1400771437-14096-2-git-send-email-horia.geanta@freescale.com>
In-Reply-To: <1400771437-14096-2-git-send-email-horia.geanta@freescale.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 22/05/2014 17:10, Horia Geanta a écrit :
> From: Lei Xu <Lei.Xu@freescale.com>
>
> Currently the sha256 icv truncation length is set to 96bit
> while the length is defined as 128bit in RFC4868.
> This may result in somer errors when working with other IPsec devices
> with the standard truncation length.
> Thus, change the sha256 truncation length from 96bit to 128bit.
The patch was already proposed, but it was kept as-is for userspace
compatibility.

See: https://lkml.org/lkml/2012/3/7/431

Regards,
Nicolas
