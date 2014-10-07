Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755305AbaJGUuW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 16:50:22 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:48537 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751988AbaJGUuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 16:50:20 -0400
Date: Tue, 07 Oct 2014 16:50:18 -0400 (EDT)
Message-Id: <20141007.165018.929111009463969597.davem@davemloft.net>
To: fabf@skynet.be
Cc: linux@roeck-us.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1 net-next] af_unix: remove NULL assignment on static
From: David Miller <davem@davemloft.net>
In-Reply-To: <1559212122.19553.1412714971908.open-xchange@webmail.nmp.skynet.be>
References: <20141007.161832.453892039501955243.davem@davemloft.net>
	<20141007203344.GA4748@roeck-us.net>
	<1559212122.19553.1412714971908.open-xchange@webmail.nmp.skynet.be>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 07 Oct 2014 13:50:20 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabian Frederick <fabf@skynet.be>
Date: Tue, 7 Oct 2014 22:49:31 +0200 (CEST)

> Maybe comment should have been "static values are automatically initialized to
> 0" then ?

Yes, that sounds a lot better, please respin.
