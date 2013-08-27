Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753689Ab3H0Qll (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 12:41:41 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:56219 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752325Ab3H0Qlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 12:41:40 -0400
Date: Tue, 27 Aug 2013 12:41:36 -0400 (EDT)
Message-Id: <20130827.124136.926975779215612126.davem@davemloft.net>
To: b.brezillon@overkiz.com
Cc: nicolas.ferre@atmel.com, rob.herring@calxeda.com, pawel.moll@arm.com,
        mark.rutland@arm.com, swarren@wwwdotorg.org, ian.campbell@citrix.com,
        linux@arm.linux.org.uk, f.fainelli@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH 0/2] net/cadence/macb: add support for dt phy definition
From: David Miller <davem@davemloft.net>
In-Reply-To: <521CD61C.8010103@overkiz.com>
References: <521C586A.7080604@overkiz.com>
	<20130827.122056.419758783951274884.davem@davemloft.net>
	<521CD61C.8010103@overkiz.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Tue, 27 Aug 2013 09:41:39 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: boris brezillon <b.brezillon@overkiz.com>
Date: Tue, 27 Aug 2013 18:38:52 +0200

> On 27/08/2013 18:20, David Miller wrote:
>> From: boris brezillon <b.brezillon@overkiz.com>
>> Date: Tue, 27 Aug 2013 09:42:34 +0200
>>
>>> Could you apply, the 3rd version of this series instead ?
>> There can never be an "instead" or reverting patches I've said I've
>> applied already.
>>
>> If you want changes, you have to submit follow-on fixes.
> 
> Hello David,
> 
> I sent the incremental patches based on your net-next branch:
> https://lkml.org/lkml/2013/8/27/257
> https://lkml.org/lkml/2013/8/27/259

The place to check to see if your patch is queued up is here:

http://patchwork.ozlabs.org/project/netdev/list/

If it's there, it's not necessary to notify me of anything.
