Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752080AbaCSRgk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 13:36:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24567 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751229AbaCSRgi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 13:36:38 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20140319065205.370836264@infradead.org>
References: <20140319065205.370836264@infradead.org> <20140319064729.660482086@infradead.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: dhowells@redhat.com, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, mingo@kernel.org, will.deacon@arm.com,
        paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH 30/31] arch,doc: Convert smp_mb__*
Date: Wed, 19 Mar 2014 17:36:04 +0000
Message-ID: <17705.1395250564@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> wrote:

> Update the documentation to reflect the change of barrier primitives.
> 
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>

Acked-by: David Howells <dhowells@redhat.com>
