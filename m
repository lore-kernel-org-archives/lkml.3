Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198Ab3JIG0H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 02:26:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16526 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751347Ab3JIG0G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 02:26:06 -0400
Message-ID: <5254F6CF.8080606@redhat.com>
Date: Wed, 09 Oct 2013 14:25:19 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>, mst@redhat.com
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, edumazet@google.com,
        xemul@parallels.com
Subject: Re: [PATCH] tun: don't look at current when non-blocking
References: <20131006182512.GA16504@redhat.com> <20131008.154614.1435858706789904414.davem@davemloft.net>
In-Reply-To: <20131008.154614.1435858706789904414.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/09/2013 03:46 AM, David Miller wrote:
> From: "Michael S. Tsirkin" <mst@redhat.com>
> Date: Sun, 6 Oct 2013 21:25:12 +0300
>
>> We play with a wait queue even if socket is
>> non blocking. This is an obvious waste.
>> Besides, it will prevent calling the non blocking
>> variant when current is not valid.
>>
>> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> Applied and queued up for -stable, thanks.
> --

Michael, I believe this is just an optimization or a required patch of
your following patches. So no need go for stable?
