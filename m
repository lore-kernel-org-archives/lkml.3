Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753438Ab3ETKN2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 06:13:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46182 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752108Ab3ETKN1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 06:13:27 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <5199AFC9.8050607@asianux.com>
References: <5199AFC9.8050607@asianux.com>
To: Chen Gang <gang.chen@asianux.com>
Cc: dhowells@redhat.com, james.l.morris@oracle.com,
        Rusty Russell <rusty@rustcorp.com.au>, dmitry.kasatkin@intel.com,
        andriy.shevchenko@linux.intel.com,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] lib/mpi/mpicoder.c: looping issue, need stop when equal to zero, found by 'EXTRA_FLAGS=-W'.
Date: Mon, 20 May 2013 11:13:17 +0100
Message-ID: <14484.1369044797@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chen Gang <gang.chen@asianux.com> wrote:

> For 'while' looping, need stop when 'nbytes == 0', or will cause issue.
> ('nbytes' is size_t which is always bigger or equal than zero).
> 
> The related warning: (with EXTRA_CFLAGS=-W)
>   lib/mpi/mpicoder.c:40:2: warning: comparison of unsigned expression >= 0 is always true [-Wtype-limits]

Acked-by: David Howells <dhowells@redhat.com>
