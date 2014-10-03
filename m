Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752520AbaJCMNd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 08:13:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63082 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752430AbaJCMNb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 08:13:31 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <542D77A4.5030606@samsung.com>
References: <542D77A4.5030606@samsung.com> <20140908153704.28301.41578.stgit@warthog.procyon.org.uk> <20140908153830.28301.37880.stgit@warthog.procyon.org.uk> <542D741D.5070109@samsung.com>
To: Dmitry Kasatkin <d.kasatkin@samsung.com>
Cc: dhowells@redhat.com, rusty@rustcorp.com.au, keyrings@linux-nfs.org,
        jwboyer@redhat.com, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, pjones@redhat.com,
        vgoyal@redhat.com
Subject: Re: [PATCH 08/13] KEYS: Overhaul key identification when searching for asymmetric keys
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <28451.1412338401.1@warthog.procyon.org.uk>
Date: Fri, 03 Oct 2014 13:13:21 +0100
Message-ID: <28452.1412338401@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Kasatkin <d.kasatkin@samsung.com> wrote:

> [  132.820302] CR2: ffffffffffffffea

Looks like I leaked an error number somewhere.

David
