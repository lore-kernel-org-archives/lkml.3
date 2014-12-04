Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753997AbaLDMwN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 07:52:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60534 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753876AbaLDMwJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 07:52:09 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <54805034.9030808@samsung.com>
References: <54805034.9030808@samsung.com> <20141126141709.3944.66589.stgit@warthog.procyon.org.uk> <20141126141720.3944.40497.stgit@warthog.procyon.org.uk>
To: Dmitry Kasatkin <d.kasatkin@samsung.com>
Cc: dhowells@redhat.com, rusty@rustcorp.com.au, mmarek@suse.cz,
        keyrings@linux-nfs.org, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, zohar@linux.vnet.ibm.com
Subject: Re: [PATCH 1/5] X.509: Extract both parts of the AuthorityKeyIdentifier [ver #2]
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <25116.1417697512.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: 8BIT
Date: Thu, 04 Dec 2014 12:51:52 +0000
Message-ID: <25117.1417697512@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Kasatkin <d.kasatkin@samsung.com> wrote:

> > +	struct asymmetric_key_id *auth_id;	/* CA AuthKeyId matching ->id (optional) */
> > +	struct asymmetric_key_id *auth_skid;	/* CA AuthKeyId matching ->skid (optional) */
> 
> Hi David,
> 
> Why do you call it "auth_skid", not just akid in similar way as 'skid'?
> Why it is "auth & skid"?

Because both auth_skid and auth_id derive from the akid.

David
