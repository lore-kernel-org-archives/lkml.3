Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762Ab3GIWZS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 18:25:18 -0400
Received: from tex.lwn.net ([70.33.254.29]:33127 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751290Ab3GIWZQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 18:25:16 -0400
Date: Tue, 9 Jul 2013 16:25:14 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Eliezer Tamir <eliezer.tamir@linux.intel.com>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Mortons <akpm@linux-foundation.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Eliezer Tamir <eliezer@tamir.org.il>
Subject: Re: [PATCH net-next] net: rename low latency sockets functions to
 busy poll
Message-ID: <20130709162514.062f1361@lwn.net>
In-Reply-To: <20130708132034.17639.4396.stgit@ladj378.jer.intel.com>
References: <20130708132034.17639.4396.stgit@ladj378.jer.intel.com>
Organization: LWN.net
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.18; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 08 Jul 2013 16:20:34 +0300
Eliezer Tamir <eliezer.tamir@linux.intel.com> wrote:

> Rename POLL_LL to POLL_BUSY_LOOP.

So pardon me if I speak out of turn, but it occurs to me to
wonder...should the SO_LL socket option be renamed in a similar fashion
before this interface escapes into the wild?

Thanks,

jon
