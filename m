Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752219Ab3FYXZA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 19:25:00 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:34927 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032Ab3FYXY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 19:24:59 -0400
Date: Tue, 25 Jun 2013 16:24:58 -0700 (PDT)
Message-Id: <20130625.162458.961275537627752359.davem@davemloft.net>
To: jasowang@redhat.com
Cc: mst@redhat.com, linux-kernel@vger.kernel.org, edumazet@google.com,
        akpm@linux-foundation.org, netdev@vger.kernel.org, bhubbard@redhat.com
Subject: Re: [PATCH net] macvtap: fix recovery from gup errors
From: David Miller <davem@davemloft.net>
In-Reply-To: <51C7BBA3.1050300@redhat.com>
References: <20130623142658.GA21141@redhat.com>
	<51C7BBA3.1050300@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Wang <jasowang@redhat.com>
Date: Mon, 24 Jun 2013 11:23:15 +0800

> On 06/23/2013 10:26 PM, Michael S. Tsirkin wrote:
>> get user pages might fail partially in macvtap zero copy
>> mode. To recover we need to put all pages that we got,
>> but code used a wrong index resulting in double-free
>> errors.
>>
>> Reported-by: Brad Hubbard <bhubbard@redhat.com>
>> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
>> ---
>>
>> Same as the tun patch really. Also stable material.
> 
> Acked-by: Jason Wang <jasowang@redhat.com>

Applied, also with the missing empty line added.
