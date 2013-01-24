Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754696Ab3AXPRB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 10:17:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45003 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753354Ab3AXPRA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 10:17:00 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1358955044-27407-3-git-send-email-mmarek@suse.cz>
References: <1358955044-27407-3-git-send-email-mmarek@suse.cz> <1358955044-27407-1-git-send-email-mmarek@suse.cz>
To: Michal Marek <mmarek@suse.cz>
Cc: dhowells@redhat.com, rusty@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] MODSIGN: Specify the hash algorithm on sign-file command line
Date: Thu, 24 Jan 2013 15:16:15 +0000
Message-ID: <28698.1359040575@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Marek <mmarek@suse.cz> wrote:

> -mod_sign_cmd = perl $(srctree)/scripts/sign-file $(MODSECKEY) $(MODPUBKEY)
> +mod_sign_cmd = perl $(srctree)/scripts/sign-file -a $(CONFIG_MODULE_SIG_HASH) $(MODSECKEY) $(MODPUBKEY)

It's mandatory, so it shouldn't really have a "-a" flag.

David
