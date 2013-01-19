Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755271Ab3ASBH5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 20:07:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37630 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753850Ab3ASBHz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 20:07:55 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1358556871-6651-1-git-send-email-sedat.dilek@gmail.com>
References: <1358556871-6651-1-git-send-email-sedat.dilek@gmail.com>
To: Sedat Dilek <sedat.dilek@gmail.com>
Cc: dhowells@redhat.com, Rusty Russell <rusty@rustcorp.com.au>,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH next-20130118 1/2] KEYS: Fix build-error when SYSTEM_TRUSTED_KEYRING=n
Date: Sat, 19 Jan 2013 01:07:45 +0000
Message-ID: <8514.1358557665@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sedat Dilek <sedat.dilek@gmail.com> wrote:

> -	select KEYS
> +	depends on KEYS

This change was pushed upstream a few hours ago.  It may not have made it into
linux-next yet.

David
