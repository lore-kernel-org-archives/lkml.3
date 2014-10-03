Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752781AbaJCMXI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 08:23:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16871 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752262AbaJCMXC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 08:23:02 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CACE9dm8ZmVJe7qadrLwXEQHYrmau_Mbahnz4FSBaWD4GB==JMw@mail.gmail.com>
References: <CACE9dm8ZmVJe7qadrLwXEQHYrmau_Mbahnz4FSBaWD4GB==JMw@mail.gmail.com> <20140908153704.28301.41578.stgit@warthog.procyon.org.uk> <20140908153830.28301.37880.stgit@warthog.procyon.org.uk> <542D741D.5070109@samsung.com> <542D77A4.5030606@samsung.com>
To: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
Cc: dhowells@redhat.com, Dmitry Kasatkin <d.kasatkin@samsung.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        keyrings <keyrings@linux-nfs.org>, Josh Boyer <jwboyer@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        pjones@redhat.com, Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 08/13] KEYS: Overhaul key identification when searching for asymmetric keys
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <28686.1412338969.1@warthog.procyon.org.uk>
Date: Fri, 03 Oct 2014 13:22:49 +0100
Message-ID: <28687.1412338969@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Kasatkin <dmitry.kasatkin@gmail.com> wrote:

> Does it still support searching for the key by partially matching
> Subject Key Identifier?

No, not at this time.  Adding partial matching support wouldn't be hard, and
given that the subjKeyId is the first part of the second key ID, that would
then work.

David
