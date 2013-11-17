Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752260Ab3KQJSK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 04:18:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22748 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752376Ab3KQJSA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 04:18:00 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1384660289.5181.8.camel@dhcp-9-2-203-236.watson.ibm.com>
References: <1384660289.5181.8.camel@dhcp-9-2-203-236.watson.ibm.com> <1384368349.2550.17.camel@dhcp-9-2-203-236.watson.ibm.com> <20131104162216.10177.98067.stgit@warthog.procyon.org.uk> <20131104162321.10177.34033.stgit@warthog.procyon.org.uk> <29885.1384451991@warthog.procyon.org.uk>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: dhowells@redhat.com, d.kasatkin@samsung.com, zohar@us.ibm.com,
        keyrings@linux-nfs.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 9/9] KEYS: Fix encrypted key type update method
Date: Sun, 17 Nov 2013 09:17:49 +0000
Message-ID: <3709.1384679869@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:

> +    keyctl control <keyid> encrypted change-master-key \
> +		"update key-type:master-key-name"

Why include the word "update" in the argument?  Isn't that implicit in the
command name?

David
