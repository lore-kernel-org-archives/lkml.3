Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754188AbaCKBvJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 21:51:09 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:49170 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861AbaCKBvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 21:51:07 -0400
Date: Mon, 10 Mar 2014 21:51:04 -0400 (EDT)
Message-Id: <20140310.215104.2095195123238829635.davem@davemloft.net>
To: ast@plumgrid.com
Cc: dborkman@redhat.com, mingo@kernel.org, wad@chromium.org,
        rostedt@goodmis.org, a.p.zijlstra@chello.nl, hpa@zytor.com,
        hagen@jauu.net, jesse@nicira.com, tglx@linutronix.de,
        edumazet@google.com, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, fweisbec@gmail.com, acme@infradead.org,
        penberg@iki.fi, arjan@infradead.org, hch@infradead.org,
        xemul@parallels.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v8 net-next 1/3] filter: add Extended BPF interpreter
 and converter
From: David Miller <davem@davemloft.net>
In-Reply-To: <1394431444-6987-2-git-send-email-ast@plumgrid.com>
References: <1394431444-6987-1-git-send-email-ast@plumgrid.com>
	<1394431444-6987-2-git-send-email-ast@plumgrid.com>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 10 Mar 2014 18:51:07 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexei Starovoitov <ast@plumgrid.com>
Date: Sun,  9 Mar 2014 23:04:02 -0700

> +	unsigned int		jited:1;

The C language has a proper type for boolean states, please therefore
use 'bool', true, and false.
