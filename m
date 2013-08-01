Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755149Ab3HAMVQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 08:21:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4162 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753884Ab3HAMVP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 08:21:15 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1374721150.1924.26.camel@joe-AO722>
References: <1374721150.1924.26.camel@joe-AO722> <1374602291.3387.17.camel@joe-AO722> <kspuuk$k2v$1@ger.gmane.org> <1374716480.1924.18.camel@joe-AO722> <20130725014732.GA10036@order.stressinduktion.org>
To: Joe Perches <joe@perches.com>
Cc: dhowells@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@canonical.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Cong Wang <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] checkpatch: Warn when using extern with function prototypes in .h files
Date: Thu, 01 Aug 2013 13:21:04 +0100
Message-ID: <25105.1375359664@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches <joe@perches.com> wrote:

> Using the extern keyword on function prototypes is superfluous
> visual noise so suggest removing it.
> 
> Using extern can cause unnecessary line wrapping at 80 columns
> and unnecessarily long multi-line function prototypes.
> 
> Suggested-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
> Signed-off-by: Joe Perches <joe@perches.com>

Nak.

The "extern" makes it much easier to pick out at a glance.

Please standardise on there _being_ externs if you must do this.

It's gratuitous change anyway and not worth the churn.

David
