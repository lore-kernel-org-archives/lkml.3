Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752569AbaLSRkm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 12:40:42 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:58061 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416AbaLSRkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 12:40:41 -0500
Date: Fri, 19 Dec 2014 12:40:38 -0500 (EST)
Message-Id: <20141219.124038.1647232478583600202.davem@davemloft.net>
To: fkan@apm.com
Cc: netdev@vger.kernel.org, patches@apm.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: eth: xgene: change APM X-Gene SoC platform
 ethernet to support ACPI
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAL85gmCOLrcTijpEhXx1x5UjHu0sgS5DdGYJxY4mwPFKCHpU-g@mail.gmail.com>
References: <1418945991-31494-1-git-send-email-fkan@apm.com>
	<20141219.123107.1080751255468272638.davem@davemloft.net>
	<CAL85gmCOLrcTijpEhXx1x5UjHu0sgS5DdGYJxY4mwPFKCHpU-g@mail.gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 19 Dec 2014 09:40:41 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Feng Kan <fkan@apm.com>
Date: Fri, 19 Dec 2014 09:36:13 -0800

> On Fri, Dec 19, 2014 at 9:31 AM, David Miller <davem@davemloft.net> wrote:
>> From: Feng Kan <fkan@apm.com>
>> Date: Thu, 18 Dec 2014 15:39:51 -0800
>>
>>> +#define NO_MAC_FOUND 0
>>> +#define RES_ENET_CSR 0
>>> +#define RES_RING_CSR 1
>>> +#define RES_RING_CMD 2
> Is there a issue with the RES defines, do you prefer enum types?

I don't have any problem with those.
