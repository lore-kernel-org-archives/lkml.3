Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753343Ab3CJWCN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 18:02:13 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:53907 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642Ab3CJWCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 18:02:12 -0400
Date: Sun, 10 Mar 2013 18:02:18 -0400 (EDT)
Message-Id: <20130310.180218.753487547136940085.davem@davemloft.net>
To: andreea.cristina.hodea@gmail.com
Cc: mac@melware.de, isdn@linux-pingi.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, hodea_andreea@yahoo.com
Subject: Re: [PATCH] eicon: Fixed checkpatch warning
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130310.165613.427736360718722534.davem@davemloft.net>
References: <1362918876-18694-1-git-send-email-hodea_andreea@yahoo.com>
	<20130310.165613.427736360718722534.davem@davemloft.net>
X-Mailer: Mew version 6.4 on Emacs 23.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Sun, 10 Mar 2013 15:02:16 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Sun, 10 Mar 2013 16:56:13 -0400 (EDT)

> From: Andreea Hodea <andreea.cristina.hodea@gmail.com>
> Date: Sun, 10 Mar 2013 14:34:36 +0200
> 
>> drivers/isdn/hardware/eicon/diva_didd.c:32:6: warning: symbol
>> 'DRIVERRELEASE_DIDD' was not declared. Should it be static?
>> 
>> Signed-off-by: Andreea Hodea <hodea_andreea@yahoo.com>
> 
> Applied, thanks.

I had to revert, did you even try to compile the driver after
this change?

The symbol is refenced by DbgRegister() calls in diddfunc.c, and
a very simple grep would have shown that to you.

Please do not just blindly try to fix checkpatch warnings.
