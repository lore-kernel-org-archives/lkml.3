Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755110Ab3LRRHF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 12:07:05 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:54908 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754998Ab3LRRHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 12:07:00 -0500
Date: Wed, 18 Dec 2013 12:06:55 -0500 (EST)
Message-Id: <20131218.120655.881363015739010955.davem@davemloft.net>
To: peterz@infradead.org
Cc: geert@linux-m68k.org, sfr@canb.auug.org.au, netdev@vger.kernel.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        ffusco@redhat.com, dborkman@redhat.com, tgraf@redhat.com
Subject: Re: linux-next: build failure after merge of the net-next tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20131218101523.GP13532@twins.programming.kicks-ass.net>
References: <20131217.213033.1019416869378407851.davem@davemloft.net>
	<CAMuHMdUi4GQYR2p7enikEkTq1s-5YwirTzmo_tS0JwiE=dVmYw@mail.gmail.com>
	<20131218101523.GP13532@twins.programming.kicks-ass.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Wed, 18 Dec 2013 09:07:00 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>
Date: Wed, 18 Dec 2013 11:15:23 +0100

> So unless there's a sane and easy way to keep it sorted; I'm going to
> ignore that rule.

Me too, it's unreasonable and of dubious value.
