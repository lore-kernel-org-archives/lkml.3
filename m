Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757588Ab3CYM4K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 08:56:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16614 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757314Ab3CYM4G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 08:56:06 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1363049291-946-4-git-send-email-lucas.demarchi@profusion.mobi>
References: <1363049291-946-4-git-send-email-lucas.demarchi@profusion.mobi> <1363049291-946-1-git-send-email-lucas.demarchi@profusion.mobi>
To: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Cc: dhowells@redhat.com, Oleg Nesterov <oleg@redhat.com>,
        lucas.de.marchi@gmail.com, James Morris <james.l.morris@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 4/7] KEYS: split call to call_usermodehelper_fns()
Date: Mon, 25 Mar 2013 12:56:00 +0000
Message-ID: <7587.1364216160@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lucas De Marchi <lucas.demarchi@profusion.mobi> wrote:

> Use call_usermodehelper_setup() + call_usermodehelper_exec() instead of
> calling call_usermodehelper_fns(). In case there's an OOM in this last
> function the cleanup function may not be called - in this case we would
> miss a call to key_put().
> 
> Signed-off-by: Lucas De Marchi <lucas.demarchi@profusion.mobi>

Acked-by: David Howells <dhowells@redhat.com>
