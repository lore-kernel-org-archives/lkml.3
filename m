Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754369AbaKXRSS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 12:18:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47856 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754338AbaKXRSP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 12:18:15 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1416830320.25352.9.camel@dhcp-9-2-203-236.watson.ibm.com>
References: <1416830320.25352.9.camel@dhcp-9-2-203-236.watson.ibm.com> <20141120165351.5264.61930.stgit@warthog.procyon.org.uk> <20141120165414.5264.95354.stgit@warthog.procyon.org.uk> <1416787243.9616.4.camel@dhcp-9-2-203-236.watson.ibm.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: dhowells@redhat.com, mmarek@suse.cz, keyrings@linux-nfs.org,
        d.kasatkin@samsung.com, rusty@rustcorp.com.au,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        vgoyal@redhat.com
Subject: Re: [Keyrings] [PATCH 2/5] X.509: Support X.509 lookup by Issuer+Serial form AuthorityKeyIdentifier
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <598.1416848314.1@warthog.procyon.org.uk>
Date: Mon, 24 Nov 2014 16:58:34 +0000
Message-ID: <599.1416848314@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:

Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:

> +        if (id) {
> +		lookup = id->data;
> +		len = id->len;
> +	}
>  	if (!lookup) {

The last line here can then just be replaced by an else-clause.

David
