Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932932AbaHYOXj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 10:23:39 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:33856 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932274AbaHYOXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 10:23:37 -0400
MIME-Version: 1.0
In-Reply-To: <1408554610.5604.11.camel@edumazet-glaptop2.roam.corp.google.com>
References: <1408459784-9385-1-git-send-email-jonas.jensen@gmail.com>
	<1408544322-32023-1-git-send-email-jonas.jensen@gmail.com>
	<1408554610.5604.11.camel@edumazet-glaptop2.roam.corp.google.com>
Date: Mon, 25 Aug 2014 16:23:35 +0200
Message-ID: <CACmBeS30_NUot6=FK3xNVDxfN+CPXNfNhEBcO4OPAOQ3Q9zQzw@mail.gmail.com>
Subject: Re: [PATCH v5 1/2] net: moxa: clear TX descriptor length bits
From: Jonas Jensen <jonas.jensen@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>, davem <davem@davemloft.net>
Cc: netdev <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        =?UTF-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirqus@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for giving feedback.

On 20 August 2014 19:10, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> Wouldnt it be faster to not use readl() at all here ?

On 22 August 2014 06:39, David Miller <davem@davemloft.net> wrote:
> Like others I wonder why the existing descriptor value is being read
> at all.

It makes sense and I have verified, transfers continue to work
clearing the whole thing, see update in v6.


Regards,

   Jonas
