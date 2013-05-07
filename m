Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756274Ab3EGFWe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 01:22:34 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:53506 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862Ab3EGFWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 01:22:33 -0400
Message-ID: <51888F93.3030300@openvz.org>
Date: Tue, 07 May 2013 09:22:27 +0400
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130119 Firefox/10.0.11esrpre Iceape/2.7.12
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: brouer@redhat.com, netdev@vger.kernel.org, edumazet@google.com,
        fw@strlen.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: frag, fix race conditions in LRU list maintenance
References: <20130505145622.9351.86587.stgit@zurg> <20130506093318.679f5557@redhat.com> <20130506.110800.1388239604905052651.davem@davemloft.net>
In-Reply-To: <20130506.110800.1388239604905052651.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Jesper Dangaard Brouer<brouer@redhat.com>
> Date: Mon, 6 May 2013 09:33:18 +0200
>
>> This a good fix, and better than my earlier attempt at fixing this.
>   ...
>> Signed-off-by: Jesper Dangaard Brouer<brouer@redhat.com>
>
> Applied, but this patch was generated against a very old tree,
> one before the q->net->nqueues stuff was added.
>
> I sorted out the conflicts but someone needs to double-check
> my work.

All right. Sorry, my patch is against 3.9

Seems like this bug allows to crash kernel remotely.
Should I send it to stable@ for including into 3.9.y or
you already have a bunch of patches for it?
