Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753784AbaKDUMQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 15:12:16 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:58893 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753706AbaKDUMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 15:12:12 -0500
Date: Tue, 04 Nov 2014 15:12:10 -0500 (EST)
Message-Id: <20141104.151210.1901212031045734478.davem@davemloft.net>
To: fabf@skynet.be
Cc: linux-kernel@vger.kernel.org, kuznet@ms2.inr.ac.ru, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net, netdev@vger.kernel.org
Subject: Re: [PATCH 1/1 net-next] ipv4: ip_frag_queue function clean-up
From: David Miller <davem@davemloft.net>
In-Reply-To: <1415130097-14490-1-git-send-email-fabf@skynet.be>
References: <1415130097-14490-1-git-send-email-fabf@skynet.be>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 04 Nov 2014 12:12:12 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabian Frederick <fabf@skynet.be>
Date: Tue,  4 Nov 2014 20:41:37 +0100

> -remove unnecessary else after break
> -declare free_it sk_buff * only once (like prev and next)
> 
> Signed-off-by: Fabian Frederick <fabf@skynet.be>

I disagree.

Declaring a local variable in it's inner-most scope is preferable
to moving it to the top level and making the job of the compiler
and the code auditor more difficult.

I'm not applying this, sorry.
