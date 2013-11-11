Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753420Ab3KKWgN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 17:36:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56826 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751807Ab3KKWgE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 17:36:04 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1384187558.18684.109.camel@dhcp-9-2-203-236.watson.ibm.com>
References: <1384187558.18684.109.camel@dhcp-9-2-203-236.watson.ibm.com> <20131104162216.10177.98067.stgit@warthog.procyon.org.uk>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: dhowells@redhat.com, d.kasatkin@samsung.com, zohar@us.ibm.com,
        keyrings@linux-nfs.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        David Safford <safford@linux.vnet.ibm.com>
Subject: Re: [RFC][PATCH 0/9] encrypted keys & key control op
Date: Mon, 11 Nov 2013 22:35:56 +0000
Message-ID: <23426.1384209356@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:

> > The control op could also be used for other things like pushing a key
> > into a TPM.
> > 
> > What do you think?
> 
> Trusted keys already creates a symmetric key based on the TPM RNG. 
> What type of key would I be interested in pushing to the TPM?   What
> usecase scenario would this solve?

Dmitry mentioned something along these lines when I talked to him in
Edinburgh.  Anyway, it was just an example suggestion.

David
