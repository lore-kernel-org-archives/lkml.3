Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753673AbaIPJIG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 05:08:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47645 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752851AbaIPJID (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 05:08:03 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <alpine.LRH.2.11.1409161215030.10183@namei.org>
References: <alpine.LRH.2.11.1409161215030.10183@namei.org> <20140910212154.10752.23343.stgit@warthog.procyon.org.uk> <27397.1410786297@warthog.procyon.org.uk>
To: James Morris <jmorris@namei.org>
Cc: dhowells@redhat.com, keyrings@linux-nfs.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] KEYS: Miscellaneous fixes
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <18405.1410858476.1@warthog.procyon.org.uk>
Date: Tue, 16 Sep 2014 10:07:56 +0100
Message-ID: <18406.1410858476@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Morris <jmorris@namei.org> wrote:

> Can you split your pull requests into different branches -- one which is 
> for current upstream, and one which is for next?

I had already done that.  But if you really want, I can punt #3 and #4 over to
linux-next.

David
