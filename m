Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756594Ab3FSHQB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 03:16:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47228 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756509Ab3FSHP7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 03:15:59 -0400
Message-ID: <51C15A9C.3080900@redhat.com>
Date: Wed, 19 Jun 2013 15:15:40 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: davem@davemloft.net, edumazet@google.com, hkchu@google.com, mst@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [net-next rfc 3/3] tuntap: increase the max queues to 16
References: <1371620452-49349-1-git-send-email-jasowang@redhat.com>  <1371620452-49349-4-git-send-email-jasowang@redhat.com> <1371623653.3252.268.camel@edumazet-glaptop>
In-Reply-To: <1371623653.3252.268.camel@edumazet-glaptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/19/2013 02:34 PM, Eric Dumazet wrote:
> On Wed, 2013-06-19 at 13:40 +0800, Jason Wang wrote:
>> Since we've reduce the size of tun_struct and use flex array to allocate netdev
>> queues, it's safe for us to increase the limit of queues in tuntap.
> Its already safe to increase max queues to 16, without your patches 1 &
> 2
>
>
>

Will send a single patch to increase it to 16.

Thanks

