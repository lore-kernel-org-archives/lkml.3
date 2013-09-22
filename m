Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752756Ab3IVSvO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 14:51:14 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:60282 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752330Ab3IVSvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 14:51:13 -0400
Date: Sun, 22 Sep 2013 11:51:04 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Joe Perches <joe@perches.com>
Cc: David Miller <davem@davemloft.net>, stephen@networkplumber.org,
        netdev@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Landley <rob@landley.net>, linux-doc@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
Subject: Re: [PATCH] stable_kernel_rules.txt: Exclude networking from stable
 rules
Message-ID: <20130922185104.GA7515@infradead.org>
References: <alpine.LRH.2.02.1309191229480.32035@file01.intranet.prod.int.rdu2.redhat.com>
 <20130919.135628.1201613770803318193.davem@davemloft.net>
 <alpine.LRH.2.02.1309191359300.12162@file01.intranet.prod.int.rdu2.redhat.com>
 <1379615474.22168.13.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379615474.22168.13.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is also the preferred way to do it for XFS.  Maybe word it in a way
that we can easily add subsystems.

To me it generally seems to be the best way to do it - having random Ccs
and lots of stable trees doesn't seem like a very good way of handling
it.

