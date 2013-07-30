Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758139Ab3G3WyO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 18:54:14 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:42901 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756180Ab3G3WyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 18:54:13 -0400
Date: Tue, 30 Jul 2013 15:54:10 -0700 (PDT)
Message-Id: <20130730.155410.1872361604983850125.davem@davemloft.net>
To: ericvh@gmail.com
Cc: sfr@canb.auug.org.au, netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, andi@etezian.org
Subject: Re: linux-next: build failure after merge of the net-next tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAFkjPTny4TUFu9xrF-90DrJwXsfzBOpb_yYOwe_0r9ohsc2vcQ@mail.gmail.com>
References: <20130730121605.35c4de9d82b753a5a763f5c9@canb.auug.org.au>
	<CAFkjPTny4TUFu9xrF-90DrJwXsfzBOpb_yYOwe_0r9ohsc2vcQ@mail.gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Tue, 30 Jul 2013 15:54:12 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Van Hensbergen <ericvh@gmail.com>
Date: Mon, 29 Jul 2013 21:30:20 -0500

> I didn't realize that had trickled in already, I can go ahead and revert
> the commit in my tree.  Neither is perfect, hopefully the folks working on
> it will get something a bit better before the next merge window.

Please revert, thanks.
