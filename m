Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754140AbaF3FqS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 01:46:18 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:46791 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342AbaF3FqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 01:46:17 -0400
MIME-Version: 1.0
In-Reply-To: <20140629212238.GA12439@kroah.com>
References: <20140627095608.GA9427@devel.8.8.4.4>
	<20140629212238.GA12439@kroah.com>
Date: Mon, 30 Jun 2014 14:46:17 +0900
Message-ID: <CAHb8M2DFNCFmKdwEcxS7cntNNJh9FZYTw=JVucQrRMneUO2o_Q@mail.gmail.com>
Subject: Re: [PATCH 2/3] staging: cxt1e1: count fragmented packet properly.
From: DaeSeok Youn <daeseok.youn@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: devel <devel@driverdev.osuosl.org>, Wolfgang Ocker <weo@weo1.de>,
        "sachin.kamat" <sachin.kamat@linaro.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Himangi Saraogi <himangi774@gmail.com>,
        Chekameh Cobbler <fempsci@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-06-30 6:22 GMT+09:00 Greg KH <gregkh@linuxfoundation.org>:
> On Fri, Jun 27, 2014 at 06:56:08PM +0900, Daeseok Youn wrote:
>> OS_mem_token_tlen() is same return value as OS_mem_token_len().
>> That means packet count is always 1. So OS_mem_token_tlen()
>> must be total length of packet and OS_mem_token_len() has a
>> length of fragmented packet. And then it can count total
>> count of fragmented packets properly.
>>
>> And OS_mem_token_next() returns NULL, it will be dereferencing
>> a NULL pointer. So it must return next fragmented packet buffer as
>> sk_buff.
>>
>> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
>> ---
>> I'm not sure of this patch and not tested.(just only build test).
>> Please review for this.
>> Thanks.
>
> Please refresh these last two based on the changes in the first one you
> should do.
OK. I will sent these again after fixing 1/3.

thanks.

Daeseok Youn.
>
> thanks,
>
> greg k-h
