Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752345Ab3BTGln (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 01:41:43 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:41672 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384Ab3BTGlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 01:41:40 -0500
Date: Wed, 20 Feb 2013 01:41:37 -0500 (EST)
Message-Id: <20130220.014137.1184382041985855584.davem@davemloft.net>
To: rientjes@google.com
Cc: mroos@ut.ee, linux-mm@vger.kernel.org, linux-kernel@vger.kernel.org,
        sparclinux@vger.kernel.org
Subject: Re: THP bug and crash on sparc64 3.8
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130219.144608.1425049879680985441.davem@davemloft.net>
References: <20130219.143320.1413047009797673492.davem@davemloft.net>
	<alpine.DEB.2.02.1302191134570.790@chino.kir.corp.google.com>
	<20130219.144608.1425049879680985441.davem@davemloft.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Tue, 19 Feb 2013 22:41:44 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ok I've written an alternative version of the fix that I've been busy
testing all evening.

I think it's much better and it's about to be posted as a series of 3
patches.

Thanks.
