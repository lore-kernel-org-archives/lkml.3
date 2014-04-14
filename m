Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755665AbaDNVXb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 17:23:31 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:37119 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754211AbaDNVX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 17:23:27 -0400
Message-ID: <1397510604.4222.63.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [BUG] A panic caused by null pointer dereference aftering
 updating to
From: Eric Dumazet <eric.dumazet@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: nasa4836@gmail.com, jchapman@katalix.com, edumazet@google.com,
        joe@perches.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Date: Mon, 14 Apr 2014 14:23:24 -0700
In-Reply-To: <20140414.152225.1983723140136958968.davem@davemloft.net>
References: <1397499566.4222.36.camel@edumazet-glaptop2.roam.corp.google.com>
	 <20140414.144843.488522666550066271.davem@davemloft.net>
	 <1397502396.4222.45.camel@edumazet-glaptop2.roam.corp.google.com>
	 <20140414.152225.1983723140136958968.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-04-14 at 15:22 -0400, David Miller wrote:


> 
> You still need to make similar transformation to ip_local_out() as mentioned
> above.

I was trying to cook a not too invasive patch.

Changing ip_local_out() means changing dst_output() / nf_hook()  and
hundred of call sites.

Unless I misunderstood you ?


