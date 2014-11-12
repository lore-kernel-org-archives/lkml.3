Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753420AbaKLUE2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 15:04:28 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:46060 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228AbaKLUE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 15:04:26 -0500
Date: Wed, 12 Nov 2014 15:04:23 -0500 (EST)
Message-Id: <20141112.150423.1660890641226643870.davem@davemloft.net>
To: haiyangz@microsoft.com
Cc: netdev@vger.kernel.org, kys@microsoft.com, olaf@aepfle.de,
        jasowang@redhat.com, linux-kernel@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org
Subject: Re: [PATCH net-next] hyperv: Add processing of MTU reduced by the
 host
From: David Miller <davem@davemloft.net>
In-Reply-To: <ecc2fd8e646147fabb30d3120c889431@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
References: <1415748472-27463-1-git-send-email-haiyangz@microsoft.com>
	<20141112.144640.703336197189868183.davem@davemloft.net>
	<ecc2fd8e646147fabb30d3120c889431@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 12 Nov 2014 12:04:26 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Haiyang Zhang <haiyangz@microsoft.com>
Date: Wed, 12 Nov 2014 20:02:11 +0000

> The Hyper-V host doesn't support MTU below 1500. If we try setting MTU to a 
> value < 1500, the host will use 1500 automatically and return 1500 in the 
> RNDIS_OID_GEN_MAXIMUM_FRAME_SIZE query and guest will also use it. That's 
> why I set the lower limit to ETH_DATA_LEN.
> 
> Are you suggesting that we keep the 68 as the lower limit, and let the host 
> auto-reset it to 1500 when we trying to set an MTU < 1500?

Then you need to add a comment, because without any information or
context that change looks wrong.
