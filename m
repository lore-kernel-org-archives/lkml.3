Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752172AbaBSGT5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 01:19:57 -0500
Received: from mail-qa0-f49.google.com ([209.85.216.49]:61972 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243AbaBSGT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 01:19:56 -0500
MIME-Version: 1.0
In-Reply-To: <20140219.010509.484470671732800480.davem@davemloft.net>
References: <1983660.RVkLooTtjT@daeseok-laptop.cloud.net>
	<20140219.010509.484470671732800480.davem@davemloft.net>
Date: Wed, 19 Feb 2014 15:14:02 +0900
Message-ID: <CAHb8M2C_eS586FgopsXNhHd9kRmfJ95v3aHRWwHTm5--DCZtNw@mail.gmail.com>
Subject: Re: [PATCH] atm: libahci: replace obselete simple_strtoul() with kstrtouint()
From: DaeSeok Youn <daeseok.youn@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: tj <tj@kernel.org>, linux-ide <linux-ide@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I re-send this patch after fixing subject.
Thanks.

Daeseok Youn

2014-02-19 15:05 GMT+09:00 David Miller <davem@davemloft.net>:
> From: Daeseok Youn <daeseok.youn@gmail.com>
> Date: Wed, 19 Feb 2014 14:09:49 +0900
>
>> From 18bd7236f36a248a0871f810cec3c1e98f098a91 Mon Sep 17 00:00:00 2001
>> From: Daeseok Youn <daeseok.youn@gmail.com>
>> Date: Wed, 19 Feb 2014 13:44:24 +0900
>> Subject: [PATCH] atm: libahci: replace obselete simple_strtoul() with
>>  kstrtouint()
>>
>> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
>
> Please fix your Subject line, you meant "ata: " not "atm: "
