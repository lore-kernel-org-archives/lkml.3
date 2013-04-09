Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935469Ab3DIGDS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 02:03:18 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:4572 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935028Ab3DIGDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 02:03:10 -0400
Message-ID: <5163AEDA.6020805@huawei.com>
Date: Tue, 9 Apr 2013 14:02:02 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: LKML <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH 1/2] netprio_cgroup: remove task_struct parameter from
 sock_update_netprio()
References: <5163AE92.7010302@huawei.com>
In-Reply-To: <5163AE92.7010302@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, please ignore it. I sent it in the wrong order...

On 2013/4/9 14:00, Li Zefan wrote:
> The callers always pass current to sock_update_netprio().
> 
> Signed-off-by: Li Zefan <lizefan@huawei.com>
> ---
>  include/net/netprio_cgroup.h | 4 ++--
>  net/core/scm.c               | 2 +-
>  net/core/sock.c              | 6 +++---
>  3 files changed, 6 insertions(+), 6 deletions(-)

