Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753807Ab3LPNp3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 08:45:29 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:53432 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753781Ab3LPNp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 08:45:27 -0500
Message-ID: <1387201524.19078.227.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [linux-next] sk->sk_dst_lock inconsistent lock state
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 16 Dec 2013 05:45:24 -0800
In-Reply-To: <20131216090412.GA2230@swordfish.minsk.epam.com>
References: <20131216090412.GA2230@swordfish.minsk.epam.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-12-16 at 12:04 +0300, Sergey Senozhatsky wrote:
> Hello,
> 
> 3.13.0-rc4-next-20131216

This is the third time we have this report.

http://patchwork.ozlabs.org/patch/301382/

Thanks


