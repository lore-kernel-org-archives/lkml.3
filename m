Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422865Ab3FUFwK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 01:52:10 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:32862 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422753Ab3FUFwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 01:52:09 -0400
MIME-Version: 1.0
In-Reply-To: <20130621100928.36a0ccf45e310f02a4dff53a@canb.auug.org.au>
References: <20130621100928.36a0ccf45e310f02a4dff53a@canb.auug.org.au>
From: Roland Dreier <roland@kernel.org>
Date: Thu, 20 Jun 2013 22:51:47 -0700
X-Google-Sender-Auth: mJj-Nq30oFhRwLpP360jW6sG92o
Message-ID: <CAG4TOxNp0h5i2tGwYxVQeV8Yk=QrvtCAp-xTxRfF2-Am44tJ9A@mail.gmail.com>
Subject: Re: linux-next: just chaeking correctness of the infiniband tree
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 20, 2013 at 5:09 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> I noticed that the infiniband tree is now based on the net-next tree.  I
> assume that is deliberate?  I do have to question how much testing that
> tree has had since it is now based on a tree that Dave only released in
> the last 24 hours ...

That is intentional since there is work coming that relies on net-next
prerequisites.

The tree hasn't had much testing, but pushing it out a few weeks
before the merge window is the way it gets testing.
