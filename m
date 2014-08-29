Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751460AbaH2WtP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 18:49:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49410 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751025AbaH2WtO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 18:49:14 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20140829175718.GA860@ada>
References: <20140829175718.GA860@ada> <20140826154129.GA4481@ada> <3614.1409225551@warthog.procyon.org.uk>
To: Andreea Bernat <bernat.ada@gmail.com>
Cc: dhowells@redhat.com, shemming@brocade.com, linux-kernel@vger.kernel.org,
        paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH RFC] rcu: assoc_array: Add critical section to avoid a bug
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <24129.1409352544.1@warthog.procyon.org.uk>
Date: Fri, 29 Aug 2014 23:49:04 +0100
Message-ID: <24130.1409352544@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreea Bernat <bernat.ada@gmail.com> wrote:

> Looks good to me.

Can I put that down as a Reviewed-by?

Thanks,
David
