Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130Ab3JSWmh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Oct 2013 18:42:37 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:34766 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752542Ab3JSWmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Oct 2013 18:42:36 -0400
MIME-Version: 1.0
In-Reply-To: <20131019.183825.2015665991258674429.davem@davemloft.net>
References: <1382188171-25595-1-git-send-email-geyslan@gmail.com>
	<20131019.183825.2015665991258674429.davem@davemloft.net>
Date: Sat, 19 Oct 2013 19:42:35 -0300
Message-ID: <CAGG-pUSMJTbGHEhCOy0PRLNN4+jyVB8oB3mca1O9sb2YbpQ-fg@mail.gmail.com>
Subject: Re: [PATCH] crypto: n2_core: insert '!err' condition in else scope
From: =?UTF-8?Q?Geyslan_Greg=C3=B3rio_Bem?= <geyslan@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: kernel-br <kernel-br@googlegroups.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "open list:CRYPTO API" <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/10/19 David Miller <davem@davemloft.net>:
> From: "Geyslan G. Bem" <geyslan@gmail.com>
> Date: Sat, 19 Oct 2013 10:09:31 -0300
>
>> This patch moves the '!err' condition into the above else scope,
>> what is more obvious and has the secondary goal of avoid false-positives
>> in statical analyze tools.
>>
>> Signed-off-by: Geyslan G. Bem <geyslan@gmail.com>
>
> I do not think patches should be applied to satisfy tools if the
> code is semantically correct.

Yes, Miller, I agree. But as I mentioned:
".. and has as the 'secondary' goal of avoid false-positives in
statical analyze tools."

The 'primary' goal is to not repeat a condition test:
"This patch moves the '!err' condition into the above else scope, what
is more obvious ..."

Thanks.
