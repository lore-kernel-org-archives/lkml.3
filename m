Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752396AbaBMGUn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 01:20:43 -0500
Received: from mail-qa0-f43.google.com ([209.85.216.43]:37146 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861AbaBMGUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 01:20:41 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1402121828020.28897@chino.kir.corp.google.com>
References: <2767883.6dX08SOjIi@daeseok-laptop.cloud.net>
	<alpine.DEB.2.02.1402121828020.28897@chino.kir.corp.google.com>
Date: Thu, 13 Feb 2014 15:20:40 +0900
Message-ID: <CAHb8M2As39jpGh=EtS9PHrpZVLEgh9Uxuhf+Y03+0P2s4H4iNg@mail.gmail.com>
Subject: Re: [PATCH] kernel/resource.c: fix sparse non static symbol warning
From: DaeSeok Youn <daeseok.youn@gmail.com>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, toshi.kani@hp.com,
        isimatu.yasuaki@jp.fujitsu.com, gong.chen@linux.intel.com,
        Kevin Hao <haokexin@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK. If I send a patch like this again, ChangeLog is written as you comment.

Thanks.
Daeseok Youn.


2014-02-13 11:28 GMT+09:00 David Rientjes <rientjes@google.com>:
> On Thu, 13 Feb 2014, Daeseok Youn wrote:
>
>> From f8e0752ac80e56bcbfe197a5820692d199822b52 Mon Sep 17 00:00:00 2001
>> From: Daeseok Youn <daeseok.youn@gmail.com>
>> Date: Thu, 13 Feb 2014 10:11:39 +0900
>> Subject: [PATCH] kernel/resource.c: fix sparse non static symbol warning
>>
>> kernel/resource.c:518:5: warning:
>>  symbol 'reallocate_resource' was not declared. Should it be static?
>>
>> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
>
> Changelog would be better if it said it's only referenced in file scope so
> it can be marked static.
>
> Acked-by: David Rientjes <rientjes@google.com>
