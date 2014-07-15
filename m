Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758071AbaGOHCh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 03:02:37 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:48439 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757279AbaGOHCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 03:02:36 -0400
X-Original-SENDERIP: 10.178.37.74
X-Original-MAILFROM: neidhard.kim@lge.com
Message-ID: <53C4D20A.2050909@lge.com>
Date: Tue, 15 Jul 2014 16:02:34 +0900
From: Jongsung Kim <neidhard.kim@lge.com>
Organization: LG Electronics
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Varka Bhadram <varkabhadram@gmail.com>, nicolas.ferre@atmel.com
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH 1/2] net: cadence: macb: add support for the WOL
References: <1405328538-29153-1-git-send-email-neidhard.kim@lge.com> <53C3ADB9.4010309@gmail.com>
In-Reply-To: <53C3ADB9.4010309@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/14/2014 07:15 PM, Varka Bhadram wrote:
> 
> I think we can do in this way:
> 
> if (phydev)
>     return phy_ethtool_set_wol(phydev, wol);
> else
>     return -ENODEV;
> 
> 
> we can save err. What do you say ...?
> 

Thank you for your comment. I just wanted the function to return
at one position. However, I'll think about your point..

