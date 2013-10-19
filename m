Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752626Ab3JSWtW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Oct 2013 18:49:22 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:40289 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875Ab3JSWtU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Oct 2013 18:49:20 -0400
Date: Sat, 19 Oct 2013 18:49:19 -0400 (EDT)
Message-Id: <20131019.184919.1292439830365652584.davem@davemloft.net>
To: geyslan@gmail.com
Cc: kernel-br@googlegroups.com, herbert@gondor.hengli.com.au,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: n2_core: insert '!err' condition in else scope
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAGG-pUSMJTbGHEhCOy0PRLNN4+jyVB8oB3mca1O9sb2YbpQ-fg@mail.gmail.com>
References: <1382188171-25595-1-git-send-email-geyslan@gmail.com>
	<20131019.183825.2015665991258674429.davem@davemloft.net>
	<CAGG-pUSMJTbGHEhCOy0PRLNN4+jyVB8oB3mca1O9sb2YbpQ-fg@mail.gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Sat, 19 Oct 2013 15:49:20 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geyslan Gregório Bem <geyslan@gmail.com>
Date: Sat, 19 Oct 2013 19:42:35 -0300

> 2013/10/19 David Miller <davem@davemloft.net>:
>> From: "Geyslan G. Bem" <geyslan@gmail.com>
>> Date: Sat, 19 Oct 2013 10:09:31 -0300
>>
>>> This patch moves the '!err' condition into the above else scope,
>>> what is more obvious and has the secondary goal of avoid false-positives
>>> in statical analyze tools.
>>>
>>> Signed-off-by: Geyslan G. Bem <geyslan@gmail.com>
>>
>> I do not think patches should be applied to satisfy tools if the
>> code is semantically correct.
> 
> Yes, Miller, I agree. But as I mentioned:
> ".. and has as the 'secondary' goal of avoid false-positives in
> statical analyze tools."
> 
> The 'primary' goal is to not repeat a condition test:
> "This patch moves the '!err' condition into the above else scope, what
> is more obvious ..."

I still do not feel that this change is a net-positive.  Sorry.
