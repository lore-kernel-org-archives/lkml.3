Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395Ab3FEIoG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 04:44:06 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:37060 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035Ab3FEIoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 04:44:03 -0400
Date: Wed, 05 Jun 2013 01:44:02 -0700 (PDT)
Message-Id: <20130605.014402.1624717193379705510.davem@davemloft.net>
To: arnd@arndb.de
Cc: andy.shevchenko@gmail.com, gregkh@linuxfoundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: core: move mac_pton() to lib/net_utils.c
From: David Miller <davem@davemloft.net>
In-Reply-To: <34263486.86xmxk21Lq@wuerfel>
References: <1370364386-5034-1-git-send-email-andy.shevchenko@gmail.com>
	<20130604.174323.350497684225826523.davem@davemloft.net>
	<34263486.86xmxk21Lq@wuerfel>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>
Date: Wed, 05 Jun 2013 10:41:45 +0200

> On Tuesday 04 June 2013 17:43:23 David Miller wrote:
>> From: Andy Shevchenko <andy.shevchenko@gmail.com>
>> Date: Tue,  4 Jun 2013 19:46:26 +0300
>> 
>> > Since we have at least one user of this function outside of CONFIG_NET
>> > scope, we have to provide this function independently. The proposed
>> > solution is to move it under lib/net_utils.c with corresponding
>> > configuration variable and select wherever it is needed.
>> > 
>> > Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
>> > Reported-by: Arnd Bergmann <arnd@arndb.de>
>> 
>> I do not see a mac_pton() usage under drivers/misc in any of my trees,
>> so I really am not the person to apply this.
> 
> Greg merged the Andy's patch that added the usage in the char-misc tree,
> which broke yesterday's linux-next for some 'randconfig' builds.
> 
> Can you provide an Ack for Greg to apply the patch to his tree?

Sure:

Acked-by: David S. Miller <davem@davemloft.net>
