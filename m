Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758702Ab3IBOmA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 10:42:00 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:35227 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754580Ab3IBOl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 10:41:59 -0400
Message-ID: <5224A18C.5060802@gmail.com>
Date: Mon, 02 Sep 2013 22:32:44 +0800
From: Ding Tianhong <dthxman@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Petr Holasek <pholasek@redhat.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ipv6: ipv6_create_tempaddr cleanup
References: <1377874958-2426-1-git-send-email-pholasek@redhat.com> <20130901183533.GB19455@order.stressinduktion.org>
In-Reply-To: <20130901183533.GB19455@order.stressinduktion.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2013/9/2 2:35, Hannes Frederic Sowa 写道:
> On Fri, Aug 30, 2013 at 05:02:38PM +0200, Petr Holasek wrote:
>> This two-liner removes max_addresses variable which is now unecessary related
>> to patch [ipv6: remove max_addresses check from ipv6_create_tempaddr].
>>
>> Signed-off-by: Petr Holasek <pholasek@redhat.com>
> Uh, yes, I missed that. Thanks a lot!
>
> Acked-by: Hannes Frederic Sowa <hannes@stressinduktion.org>

Acked-by: Ding Tianhong <dingtianhong@huawei.com>
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

