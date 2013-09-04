Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762014Ab3IDGBx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 02:01:53 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:62974 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761399Ab3IDGBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 02:01:52 -0400
Date: Wed, 4 Sep 2013 11:31:38 +0530 (IST)
From: Govindarajulu Varadarajan <govindarajulu90@gmail.com>
X-X-Sender: hydrogen@as-rtp-nw.cisco.com
To: Govindarajulu Varadarajan <govindarajulu90@gmail.com>
cc: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        benve@cisco.com, ssujith@cisco.com, nistrive@cisco.com,
        umalhi@cisco.com
Subject: Re: [PATCH net-next 3/5] driver/net: enic: Try DMA 64 first, then
 failover to DMA
In-Reply-To: <1378273638-7780-4-git-send-email-govindarajulu90@gmail.com>
Message-ID: <alpine.LNX.2.03.1309041127380.1814@gmail.com>
References: <1378273638-7780-1-git-send-email-govindarajulu90@gmail.com> <1378273638-7780-4-git-send-email-govindarajulu90@gmail.com>
User-Agent: Alpine 2.03 (LNX 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave

The subject for this should be "driver/net: enic: Try DMA 64 first, then
failover to DMA 32"

The "32" got truncated, please add this while committing. Let me know if
you want me to send another patch.

thanks
//govind

On Wed, 4 Sep 2013, Govindarajulu Varadarajan wrote:

> In servers with more than 1.1 TB of RAM, the existing 40/32 bit DMA
> could cause failure as the DMA-able address could go outside the range
> addressable using 40/32 bits.
>
> The following patch first tried 64 bit DMA if possible, failover to 32
> bit.
>
> Signed-off-by: Sujith Sankar <ssujith@cisco.com>
> Signed-off-by: Christian Benvenuti <benve@cisco.com>
> Signed-off-by: Govindarajulu Varadarajan <govindarajulu90@gmail.com>
