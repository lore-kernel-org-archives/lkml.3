Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936406Ab3DHO2m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 10:28:42 -0400
Received: from ozlabs.org ([203.10.76.45]:33034 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936221Ab3DHO2j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 10:28:39 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Amit Shah <amit.shah@redhat.com>, Wei Yongjun <weiyj.lk@gmail.com>
Cc: arnd@arndb.de, gregkh@linuxfoundation.org, yongjun_wei@trendmicro.com.cn,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] virtio_console: make local symbols static
In-Reply-To: <20130408055354.GC16207@amit.redhat.com>
References: <CAPgLHd8ffGFuLdAFnx=bDmBS5U0FrH-fqCeneOHeWQQSE+v4wg@mail.gmail.com> <20130408055354.GC16207@amit.redhat.com>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Mon, 08 Apr 2013 22:58:45 +0930
Message-ID: <87d2u59mnm.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Amit Shah <amit.shah@redhat.com> writes:

> On (Sat) 06 Apr 2013 [11:52:07], Wei Yongjun wrote:
>> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>> 
>> Those symbols only used within this file, and should be static.
>> 
>> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>
> Acked-by: Amit Shah <amit.shah@redhat.com>
>
> 		Amit

Thanks, applied.

Cheers,
Rusty.
