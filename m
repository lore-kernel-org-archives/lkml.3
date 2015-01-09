Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757019AbbAINlf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 08:41:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42201 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751748AbbAINle (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 08:41:34 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1420801841-6721-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1420801841-6721-1-git-send-email-linux@rasmusvillemoes.dk>
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: dhowells@redhat.com, Rusty Russell <rusty@rustcorp.com.au>,
        d.kasatkin@samsung.com, keyrings@linux-nfs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MPILIB: Fix obvious but harmless typo
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <6725.1420810872.1@warthog.procyon.org.uk>
Date: Fri, 09 Jan 2015 13:41:12 +0000
Message-ID: <6726.1420810872@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rasmus Villemoes <linux@rasmusvillemoes.dk> wrote:

> The macro MPN_COPY_INCR this occurs in isn't used anywhere.

Applied.

David
