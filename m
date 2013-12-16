Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755305Ab3LPS4Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 13:56:16 -0500
Received: from mail-la0-f49.google.com ([209.85.215.49]:60660 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755017Ab3LPS4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 13:56:14 -0500
Date: Mon, 16 Dec 2013 21:53:39 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [linux-next] sk->sk_dst_lock inconsistent lock state
Message-ID: <20131216185339.GA2319@swordfish>
References: <20131216090412.GA2230@swordfish.minsk.epam.com>
 <1387201524.19078.227.camel@edumazet-glaptop2.roam.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387201524.19078.227.camel@edumazet-glaptop2.roam.corp.google.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (12/16/13 05:45), Eric Dumazet wrote:
> On Mon, 2013-12-16 at 12:04 +0300, Sergey Senozhatsky wrote:
> > Hello,
> > 
> > 3.13.0-rc4-next-20131216
> 
> This is the third time we have this report.
>

sorry.
nice, thanks for the info.

	-ss

> http://patchwork.ozlabs.org/patch/301382/
> 
> Thanks
> 
> 
