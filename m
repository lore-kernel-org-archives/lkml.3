Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755872Ab3AYALR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 19:11:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25604 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752277Ab3AYALF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 19:11:05 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1359062429-27295-3-git-send-email-mmarek@suse.cz>
References: <1359062429-27295-3-git-send-email-mmarek@suse.cz> <1359062429-27295-1-git-send-email-mmarek@suse.cz>
To: Michal Marek <mmarek@suse.cz>
Cc: dhowells@redhat.com, rusty@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/4] MODSIGN: Add -s <signature> option to sign-file
Date: Fri, 25 Jan 2013 00:10:18 +0000
Message-ID: <9497.1359072618@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Marek <mmarek@suse.cz> wrote:

> This option allows to append an externally computed singature to the
> module. This is needed in setups, where the private key is not directly
> available, but a service exists that returns signatures for given files.
> 
> Signed-off-by: Michal Marek <mmarek@suse.cz>
> ---
> v2: Use two-argument version of getopts to avoid global variables
>     Use parentheses in EXPR if (...) constructs

Feel free to add:

Acked-by: David Howells <dhowells@redhat.com>

to your patches.
