Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752080AbaCFWc5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 17:32:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47630 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750919AbaCFWcz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 17:32:55 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20140306.171656.1597596195712774395.davem@davemloft.net>
References: <20140306.171656.1597596195712774395.davem@davemloft.net> <20140306.143719.2217501178599478723.davem@davemloft.net> <20140306124614.16645.50744.stgit@warthog.procyon.org.uk> <8007.1394144113@warthog.procyon.org.uk>
To: David Miller <davem@davemloft.net>
Cc: dhowells@redhat.com, netdev@vger.kernel.org, tim@electronghost.co.uk,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/8] AF_RXRPC fixes and development [ver #2]
Date: Thu, 06 Mar 2014 22:32:29 +0000
Message-ID: <8493.1394145149@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller <davem@davemloft.net> wrote:

> If you do, submit just the bug fixes against 'net'

One more question:  When you say "against 'net'", do you mean a particular
branch of a git tree?  If so, disregard the pull request I just sent you and
I'll rebase.

David
