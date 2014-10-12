Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752564AbaJLRau (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 13:30:50 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:51061 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752413AbaJLRat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 13:30:49 -0400
Date: Sun, 12 Oct 2014 13:30:47 -0400 (EDT)
Message-Id: <20141012.133047.427141450441745027.davem@davemloft.net>
To: js1304@gmail.com
Cc: linux-kernel@vger.kernel.org, cl@linux.com, penberg@kernel.org,
        rientjes@google.com, iamjoonsoo.kim@lge.com, akpm@linux-foundation.org,
        linux-mm@kvack.org
Subject: Re: unaligned accesses in SLAB etc.
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAAmzW4Nrzp8TKurmevqmAV5kVRP2af1wZKqYcYH9RXroTZavpw@mail.gmail.com>
References: <20141011.221510.1574777235900788349.davem@davemloft.net>
	<CAAmzW4Nrzp8TKurmevqmAV5kVRP2af1wZKqYcYH9RXroTZavpw@mail.gmail.com>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sun, 12 Oct 2014 10:30:49 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joonsoo Kim <js1304@gmail.com>
Date: Mon, 13 Oct 2014 02:22:15 +0900

> Could you test below patch?
> If it fixes your problem, I will send it with proper description.

It works, I just tested using ARCH_KMALLOC_MINALIGN which would be
better.
