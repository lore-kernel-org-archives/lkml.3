Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751681AbaLEKYP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 05:24:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44856 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750743AbaLEKYN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 05:24:13 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <548172DE.9090007@samsung.com>
References: <548172DE.9090007@samsung.com> <20141126141709.3944.66589.stgit@warthog.procyon.org.uk> <20141126141753.3944.22213.stgit@warthog.procyon.org.uk>
To: Dmitry Kasatkin <d.kasatkin@samsung.com>
Cc: dhowells@redhat.com, rusty@rustcorp.com.au, mmarek@suse.cz,
        keyrings@linux-nfs.org, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, zohar@linux.vnet.ibm.com
Subject: Re: [PATCH 4/5] MODSIGN: Provide a utility to append a PKCS#7 signature to a module [ver #2]
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <23279.1417775034.1@warthog.procyon.org.uk>
Date: Fri, 05 Dec 2014 10:23:54 +0000
Message-ID: <23280.1417775034@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Kasatkin <d.kasatkin@samsung.com> wrote:

> sign-file.c produce lots of annoying noise.

How did you get it to produce that?

David
