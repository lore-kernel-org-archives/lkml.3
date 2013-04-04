Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764386Ab3DDVqh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 17:46:37 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:50691 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761901Ab3DDVqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 17:46:36 -0400
Date: Thu, 04 Apr 2013 17:46:33 -0400 (EDT)
Message-Id: <20130404.174633.55409356599454602.davem@davemloft.net>
To: romieu@fr.zoreil.com
Cc: hayeswang@realtek.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bowgotsai@google.com
Subject: Re: [PATCH v2] r8169: fix auto speed down issue
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130402213736.GA15328@electric-eye.fr.zoreil.com>
References: <1364541062-9024-1-git-send-email-hayeswang@realtek.com>
	<1364785324-1604-1-git-send-email-hayeswang@realtek.com>
	<20130402213736.GA15328@electric-eye.fr.zoreil.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Thu, 04 Apr 2013 14:46:35 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Francois Romieu <romieu@fr.zoreil.com>
Date: Tue, 2 Apr 2013 23:37:36 +0200

> Hayes Wang <hayeswang@realtek.com> :
>> It would cause no link after suspending or shutdowning when the
>> nic changes the speed to 10M and connects to a link partner which
>> forces the speed to 100M.
>> 
>> Check the link partner ability to determine which speed to set.
>> 
>> Signed-off-by: Hayes Wang <hayeswang@realtek.com>
> 
> Acked-by: Francois Romieu <romieu@fr.zoreil.com>

Applied.

>> +static void rtl_speed_down(struct rtl8169_private *tp)
>> +{
>> +	u32	adv;
>> +	int	lpa;
>            ^^^^^
> Please use a single, true space (no tabs) next time.

I fixed this up when I applied this patch, thanks.
