Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756173Ab3BTGnP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 01:43:15 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:47492 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752454Ab3BTGnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 01:43:12 -0500
Message-ID: <51247076.5000003@gmail.com>
Date: Wed, 20 Feb 2013 14:43:02 +0800
From: Cong Wang <xiyou.wangcong@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sasha Levin <sasha.levin@oracle.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: linux-next: manual merge of the akpm tree with the net-next tree
References: <20130220170223.806c3c5e9f240d8bacc7c940@canb.auug.org.au>
In-Reply-To: <20130220170223.806c3c5e9f240d8bacc7c940@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20/2013 02:02 PM, Stephen Rothwell wrote:
> Hi Andrew,
>
> Today's linux-next merge of the akpm tree got a conflict in
> net/core/dev.c between commit 900ff8c63214 ("net: move procfs code to
> net/core/net-procfs.c") from the net-next tree and commit "hlist: drop
> the node parameter from iterators" from the akpm tree.
>
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).
>

Looks good.

Thanks, Stephen!

