Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761127AbaGRKGm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 06:06:42 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:54258 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756021AbaGRKGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 06:06:40 -0400
Message-ID: <53C8F162.9020304@gmail.com>
Date: Fri, 18 Jul 2014 15:35:22 +0530
From: Varka Bhadram <varkabhadram@gmail.com>
Organization: CDAC-HYD
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Neil Armstrong <superna9999@gmail.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] net: macb: Handle errors in RX path
References: <53C8EE99.6070605@gmail.com>
In-Reply-To: <53C8EE99.6070605@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/2014 03:23 PM, Neil Armstrong wrote:
> In certain circumstances, the MACB fails to write correct RX ring
> descriptor, and lead to actually managed by BUG_ON() error cases.
>
> Handle these two cases by returning error values, while resetting
> the RX ring and RX HW path in the poll methos.
>
> In the same time, check and handle BNA and OVR into poll method
> by using the same error management.
>
> Signed-off-by: Neil Armstrong <narmstrong@neotion.com>
> ---
>   drivers/net/ethernet/cadence/macb.c |   55 +++++++++++++++++++++++++++++++---
>   1 files changed, 50 insertions(+), 5 deletions(-)
>
checkpatch errors/warnings on this patch...

-- 
Regards,
Varka Bhadram.

