Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755823AbaAFQki (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 11:40:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11815 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755354AbaAFQkd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 11:40:33 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20140106124225.GQ31886@sirena.org.uk>
References: <20140106124225.GQ31886@sirena.org.uk> <20140103160755.8153.81654.stgit@warthog.procyon.org.uk>
To: Mark Brown <broonie@kernel.org>
Cc: dhowells@redhat.com, akpm@linux-foundation.org,
        Laxman Dewangan <ldewangan@nvidia.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/7] Fix up a pointer-integer size mismatch warning in tps62360_probe()
Date: Mon, 06 Jan 2014 16:40:28 +0000
Message-ID: <13465.1389026428@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Brown <broonie@kernel.org> wrote:

> you need to CC things to maintainers

	warthog>grep -i tps6 MAINTAINERS 
	warthog1>

I cc'd Laxman who is the only person mentioned in the file.

I cc'd you who is mentioned in the "regulator" section and who appears in
sign-offs in the log.

There is no "regulator" list in the MAINTAINERS file.

David
