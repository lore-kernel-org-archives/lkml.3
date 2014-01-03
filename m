Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751223AbaACFUc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 00:20:32 -0500
Received: from mail-ob0-f169.google.com ([209.85.214.169]:42002 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753AbaACFUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 00:20:30 -0500
MIME-Version: 1.0
In-Reply-To: <52C62A44.4070304@huawei.com>
References: <52C62A44.4070304@huawei.com>
Date: Thu, 2 Jan 2014 21:20:30 -0800
Message-ID: <CAM_iQpW0+Ftvk=QBE+0yMNW00VkBee1+yAEmbPkT+zjij9RX-Q@mail.gmail.com>
Subject: Re: [RFC PATCH net-next 0/4] net_cls for sys container
From: Cong Wang <xiyou.wangcong@gmail.com>
To: Libo Chen <clbchenlibo.chen@huawei.com>
Cc: David Miller <davem@davemloft.net>, Jamal Hadi Salim <jhs@mojatatu.com>,
        Li Zefan <lizefan@huawei.com>, Eric Dumazet <edumazet@google.com>,
        pshelar@nicira.com, jasowang@redhat.com,
        Simon Horman <horms@verge.net.au>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        cgroups@vger.kernel.org, containers@lists.linux-foundation.org,
        Patrick McHardy <kaber@trash.net>, xemul@openvz.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 2, 2014 at 7:11 PM, Libo Chen <clbchenlibo.chen@huawei.com> wrote:
> Hi guys,
>
> Now, lxc created with veth can not be under control by
> cls_cgroup.
>
> the former discussion:
> http://lkml.indiana.edu/hypermail/linux/kernel/1312.1/00214.html
>
> In short, because cls_cgroup relys classid attached to sock
> filter skb, but sock will be cleared inside dev_forward_skb()
> in veth_xmit().


So what are you trying to achieve here?
