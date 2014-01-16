Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752448AbaAPMcl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 07:32:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9693 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752011AbaAPMch (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 07:32:37 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1389249983-31265-1-git-send-email-jlee@suse.com>
References: <1389249983-31265-1-git-send-email-jlee@suse.com>
To: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
Cc: dhowells@redhat.com, rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
        Chun-Yi Lee <jlee@suse.com>, Josh Boyer <jwboyer@redhat.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Michal Marek <mmarek@suse.com>
Subject: Re: [PATCH] MODSIGN: Fix including certificate twice when the signing_key.x509
Date: Thu, 16 Jan 2014 12:31:03 +0000
Message-ID: <10837.1389875463@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lee, Chun-Yi <joeyli.kernel@gmail.com> wrote:

> This issue was found in devel-pekey branch on linux-modsign.git tree.
> The

Are you asking for this to go upstream or into my devel-pekey branch?

If upstream you want it to go upstream, I presume commit
d7ec435fdd03cfee70dba934ee384acc87bd6d00 doesn't fix the problem?

David
