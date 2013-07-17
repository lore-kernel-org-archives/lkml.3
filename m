Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757000Ab3GQVBn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 17:01:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4903 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752451Ab3GQVBl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 17:01:41 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1374094436.1949.109.camel@joe-AO722>
References: <1374094436.1949.109.camel@joe-AO722> <20130717204314.8591.52892.stgit@warthog.procyon.org.uk> <20130717204330.8591.39362.stgit@warthog.procyon.org.uk>
To: Joe Perches <joe@perches.com>
Cc: dhowells@redhat.com, keyrings@linux-nfs.org,
        linux-security-module@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/10] Add a generic associative array implementation.
Date: Wed, 17 Jul 2013 22:01:31 +0100
Message-ID: <9037.1374094891@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches <joe@perches.com> wrote:

> bool type makes me queasy.

:-)

I've no particular objection to naming it something else - but what?  'Mark'
maybe?

David
