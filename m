Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753217Ab3BUOQZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 09:16:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30500 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752344Ab3BUOQY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 09:16:24 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1361445829-23594-1-git-send-email-jlee@suse.com>
References: <1361445829-23594-1-git-send-email-jlee@suse.com>
To: Chun-Yi Lee <joeyli.kernel@gmail.com>
Cc: dhowells@redhat.com, rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
        Chun-Yi Lee <jlee@suse.com>, Josh Boyer <jwboyer@redhat.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Michal Marek <mmarek@suse.com>
Subject: Re: [PATCH] MODSIGN: Fix including certificate twice when the signing_key.x509 already exists
Date: Thu, 21 Feb 2013 14:16:05 +0000
Message-ID: <804.1361456165@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> +ifneq ($(shell pwd), $(srctree))

How reliable is this, I wonder?

David
