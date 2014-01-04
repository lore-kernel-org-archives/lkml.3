Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754453AbaADAfm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 19:35:42 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:35383 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754196AbaADAfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 19:35:41 -0500
Date: Fri, 03 Jan 2014 19:35:39 -0500 (EST)
Message-Id: <20140103.193539.332685938065529152.davem@davemloft.net>
To: grantgrundler@gmail.com
Cc: Julia.Lawall@lip6.fr, grundler@parisc-linux.org,
        kernel-janitors@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: tulip: delete useless tests on netdev_priv
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAP6odjhqzKPiBdxQVm5BbbOFwiekJu66_WgSE+E4g_nkHh+-dQ@mail.gmail.com>
References: <1388680129-13661-1-git-send-email-Julia.Lawall@lip6.fr>
	<CAP6odjhqzKPiBdxQVm5BbbOFwiekJu66_WgSE+E4g_nkHh+-dQ@mail.gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Fri, 03 Jan 2014 16:35:40 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grant Grundler <grantgrundler@gmail.com>
Date: Thu, 2 Jan 2014 07:57:26 -0800

> On Thu, Jan 2, 2014 at 8:28 AM, Julia Lawall <Julia.Lawall@lip6.fr> wrote:
>> From: Julia Lawall <Julia.Lawall@lip6.fr>
>>
>> Netdev_priv performs an addition, not a pointer dereference, so it seems
>> quit unlikely that its result would ever be NULL.
> 
> LGTM.
> 
>  >
>> A semantic patch that makes this change is as follows:
>> (http://coccinelle.lip6.fr/)
>>
>> // <smpl>
>> @@
>> statement S;
>> @@
>>
>> - if (!netdev_priv(...)) S
>> // </smpl>
>>
>> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> Acked-by: Grant Grundler <grundler@parisc-linux.org>

Applied, thanks everyone.
