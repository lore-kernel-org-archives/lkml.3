Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041AbaKXNgF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 08:36:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40856 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750871AbaKXNgD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 08:36:03 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20141121144245.GA22306@redhat.com>
References: <20141121144245.GA22306@redhat.com> <20141120165351.5264.61930.stgit@warthog.procyon.org.uk> <20141120165403.5264.18275.stgit@warthog.procyon.org.uk>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: dhowells@redhat.com, mmarek@suse.cz, d.kasatkin@samsung.com,
        rusty@rustcorp.com.au, keyrings@linux-nfs.org,
        linux-security-module@vger.kernel.org, zohar@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] X.509: Extract both parts of the AuthorityKeyIdentifier
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <15722.1416836145.1@warthog.procyon.org.uk>
Date: Mon, 24 Nov 2014 13:35:45 +0000
Message-ID: <15723.1416836145@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal <vgoyal@redhat.com> wrote:

> A very minor nit. It might help if we put additional comment to explain what
> auth_id and auth_skid are composed of (like other key ids).

I thought it better to show what they match - ie. auth_id matches id and
auth_skid matches skid from the same structure.  The id and skid members show
their composition (and I should fix the comment on id so that the bits are the
right way round).

David
