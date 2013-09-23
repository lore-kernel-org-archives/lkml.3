Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753018Ab3IWFBN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 01:01:13 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:44672 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838Ab3IWFBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 01:01:12 -0400
Date: Mon, 23 Sep 2013 01:01:07 -0400 (EDT)
Message-Id: <20130923.010107.654735754325530643.davem@davemloft.net>
To: benh@kernel.crashing.org
Cc: fweisbec@gmail.com, torvalds@linux-foundation.org, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, paulus@au1.ibm.com, mingo@kernel.org,
        peterz@infradead.org, hpa@zytor.com, james.hogan@imgtec.com,
        jejb@parisc-linux.org, deller@gmx.de, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, akpm@linux-foundation.org
Subject: Re: [RFC GIT PULL] softirq: Consolidation and stack overrun fix
From: David Miller <davem@davemloft.net>
In-Reply-To: <1379911234.6625.7.camel@pasglop>
References: <CAFTL4hzucS5nJbCrArPv9zfY=QpyUESMK2Th0tKFHVCjDP7-eA@mail.gmail.com>
	<1379799901.24090.6.camel@pasglop>
	<1379911234.6625.7.camel@pasglop>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Sun, 22 Sep 2013 22:01:11 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Mon, 23 Sep 2013 14:40:34 +1000

> Heads up guys: i386 and sparc at least seem to need the same
> treatment.

I'll take a look thanks for the heads up.

