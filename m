Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349AbaDOSqr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 14:46:47 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:41347 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754332AbaDOSqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 14:46:43 -0400
MIME-Version: 1.0
In-Reply-To: <534D7244.5000002@citrix.com>
References: <1397583579-32162-1-git-send-email-v.maffione@gmail.com>
	<534D7244.5000002@citrix.com>
Date: Tue, 15 Apr 2014 20:46:43 +0200
Message-ID: <CA+_eA9gAqyKyFXbGZpUQiDqA2jVWAWUbE3cbeXhRtSFZGmh3jg@mail.gmail.com>
Subject: Re: [PATCH] drivers: net: xen-netfront: remove unused arrays
From: Vincenzo Maffione <v.maffione@gmail.com>
To: David Vrabel <david.vrabel@citrix.com>
Cc: konrad.wilk@oracle.com, boris.ostrovsky@oracle.com,
        xen-devel@lists.xenproject.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-04-15 19:54 GMT+02:00 David Vrabel <david.vrabel@citrix.com>:
> On 15/04/14 18:39, Vincenzo Maffione wrote:
>> This patch removes some unused arrays from the netfront
>> private data structure.
>> Also removes an unused address variable.
>>
>> Signed-off-by: Vincenzo Maffione <v.maffione@gmail.com>
>
> Huh. I wonder what they were for.
>
> Acked-by: David Vrabel <david.vrabel@citrix.com>
>
> For net related patches please say whether they're for the net (current
> RCs) or net-next branch.  e.g.,
>
> [PATCH net-next] xen-netfront: removed unused arrays.
>
Ok, thanks.

I used linux-next
   git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
but I don't really know what is the most appropriate.
(I guess git://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git is "net"?)

Vincenzo

> Thanks.
>
> David



-- 
Vincenzo Maffione
