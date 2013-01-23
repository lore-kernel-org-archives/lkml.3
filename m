Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754975Ab3AWMu5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 07:50:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52425 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754707Ab3AWMu4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 07:50:56 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <50FFCAC4.1050002@synopsys.com>
References: <50FFCAC4.1050002@synopsys.com> <1358511930-7424-1-git-send-email-vgupta@synopsys.com> <1358511930-7424-66-git-send-email-vgupta@synopsys.com>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: dhowells@redhat.com, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, arnd@arndb.de
Subject: Re: [PATCH v2 65/76] ARC: UAPI Disintegrate arch/arc/include/asm
Date: Wed, 23 Jan 2013 12:50:25 +0000
Message-ID: <10760.1358945425@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vineet Gupta <Vineet.Gupta1@synopsys.com> wrote:

> I generated this patch using the scripts you provided. If these look OK to
> you, can you please ACK.

You need to take a look at uapi/asm/setup.h.  It's created as an empty file -
which will get discarded by patch.  Do you actually need a UAPI instance of
that?

David
