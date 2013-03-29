Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755836Ab3C2Ozb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 10:55:31 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:59891 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754423Ab3C2Oz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 10:55:29 -0400
Message-ID: <5155AB11.60009@cogentembedded.com>
Date: Fri, 29 Mar 2013 18:54:09 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Alexandru Copot <alex.mihai.c@gmail.com>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, davem@davemloft.net,
        honkiko@gmail.com, tgraf@suug.ch
Subject: Re: [PATCH net-next] audit: pass int* to nlmsg_next
References: <1364506289-9146-1-git-send-email-alex.mihai.c@gmail.com>
In-Reply-To: <1364506289-9146-1-git-send-email-alex.mihai.c@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 29-03-2013 1:31, Alexandru Copot wrote:

> Commit 941912133025926307c7a65b203fa38403b1063a

    Please also specify the summary line of that commit in parens (or however 
you like).
    With that, you can add my:

Acked-by: Sergei Shtylyov <segei.shtylyov@cogentembedded.com>

> replaced the macros
> NLMSG_NEXT with calls to nlmsg_next which produces this warning:

> kernel/audit.c: In function ‘audit_receive_skb’:
> kernel/audit.c:928:3: warning: passing argument 2 of ‘nlmsg_next’ makes pointer from integer without a cast
> In file included from include/net/rtnetlink.h:5:0,
>                   from include/net/neighbour.h:28,
>                   from include/net/dst.h:17,
>                   from include/net/sock.h:68,
>                   from kernel/audit.c:55:
> include/net/netlink.h:359:1: note: expected ‘int *’ but argument is of type ‘int’

> Fix this by sending the intended pointer.

> Signed-off-by: Alexandru Copot <alex.mihai.c@gmail.com>

WBR, Sergei

