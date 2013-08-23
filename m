Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756224Ab3HWUg7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 16:36:59 -0400
Received: from dcvr.yhbt.net ([64.71.152.64]:38559 "EHLO dcvr.yhbt.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755196Ab3HWUg5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 16:36:57 -0400
Date: Fri, 23 Aug 2013 20:36:56 +0000
From: Eric Wong <normalperson@yhbt.net>
To: Eliezer Tamir <eliezer.tamir@linux.intel.com>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, e1000-devel@lists.sourceforge.net,
        Eilon Greenstein <eilong@broadcom.com>,
        Amir Vadai <amirv@mellanox.com>, Eric Dumazet <erdnetdev@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Eliezer Tamir <eliezer@tamir.org.il>
Subject: Re: [PATCH RFC net-next] net: epoll support for busy poll
Message-ID: <20130823203656.GA474@dcvr.yhbt.net>
References: <20130821103954.30607.6819.stgit@ladj378.jer.intel.com>
 <20130822201135.GA4088@dcvr.yhbt.net>
 <52170E78.1010704@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52170E78.1010704@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eliezer Tamir <eliezer.tamir@linux.intel.com> wrote:
> I'm not sure I understand your claim that epoll has a higher latency
> than poll.

Nevermind, I usually live in an EPOLLONESHOT bubble so I use more
epoll_ctl than "normal" epoll apps :x

Anyways, good to know epoll wins over poll.  Thanks.
