Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755268AbaGQG7m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 02:59:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47508 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755216AbaGQG7j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 02:59:39 -0400
Message-ID: <53C7744E.60806@redhat.com>
Date: Thu, 17 Jul 2014 14:59:26 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: rusty@rustcorp.com.au, mst@redhat.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next V2 0/3] rx busy polling support for virtio-net
References: <1405491707-22706-1-git-send-email-jasowang@redhat.com> <20140716.232116.802194909968085691.davem@davemloft.net>
In-Reply-To: <20140716.232116.802194909968085691.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17/2014 02:21 PM, David Miller wrote:
> From: Jason Wang <jasowang@redhat.com>
> Date: Wed, 16 Jul 2014 14:21:44 +0800
>
>> Hi all:
>>
>> This series introduces the support for rx busy polling support. This
>> was useful for reduing the latency for a kvm guest. Patch 1-2
>> introduces helpers which is used for rx busy polling. Patch 3
>> implement the main function.
>>
>> Test was done between a kvm guest and an external host. Two hosts were
>> connected through 40gb mlx4 cards. With both busy_poll and busy_read are
>> set to 50 in guest, 1 byte netperf tcp_rr shows 116% improvement:
>> transaction rate was increased from 9151.94 to 19787.37.
>>
>> Changes from V1:
>> - split the patch info smaller ones
>> - add more details about test setup/configuration
>>
>> Please review.
> Looks like you can make some minor adjustments based upon review, and
> anyways I'd like to wait for Michael to get back and review a change
> of this nature.
>
> Thanks.

Ok, I will wait for Michael's comments and then post V3.

Thanks
