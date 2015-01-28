Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756092AbbA1VE5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 16:04:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45361 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754643AbbA1U4U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:56:20 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <16372019.BFlLRod3Eu@wuerfel>
References: <16372019.BFlLRod3Eu@wuerfel>
To: Arnd Bergmann <arnd@arndb.de>
Cc: dhowells@redhat.com, Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] MPILIB: avoid assembler warning
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <9571.1422463347.1@warthog.procyon.org.uk>
Date: Wed, 28 Jan 2015 16:42:27 +0000
Message-ID: <9572.1422463347@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann <arnd@arndb.de> wrote:

> Not sure who would be the best person to pick this patch up.

I can pick it up, but I wonder if the MPI asm bits should be distributed to
asm/mpilib.h headers rather than being in the lib/ directory.

David
