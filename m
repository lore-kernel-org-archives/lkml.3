Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751361AbaKQGOn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 01:14:43 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:41331 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740AbaKQGOm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 01:14:42 -0500
Date: Mon, 17 Nov 2014 01:12:44 -0500 (EST)
Message-Id: <20141117.011244.411942491718443458.davem@davemloft.net>
To: linus.luessing@c0d3.blue
Cc: netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        stephen@networkplumber.org, herbert@gondor.apana.org.au,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bridge: fix netfilter/NF_BR_LOCAL_OUT for own, locally
 generated queries
From: David Miller <davem@davemloft.net>
In-Reply-To: <20141117020816.GD2469@odroid>
References: <1411342364-4791-1-git-send-email-linus.luessing@web.de>
	<20141102220145.GA25604@gondor.apana.org.au>
	<20141117020816.GD2469@odroid>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sun, 16 Nov 2014 22:14:15 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Lüssing <linus.luessing@c0d3.blue>
Date: Mon, 17 Nov 2014 03:08:16 +0100

> On Mon, Nov 03, 2014 at 06:01:46AM +0800, Herbert Xu wrote:
>> On Mon, Sep 22, 2014 at 01:32:44AM +0200, Linus Lüssing wrote:
>> > Signed-off-by: Linus Lüssing <linus.luessing@web.de>
>> 
>> Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
> 
> Hi David,
> 
> are there any unanswered questions left?

I expect to get this from the netfilter folks, since it is a
netfilter change.  So you should submit it to the netfilter
maintainers.
