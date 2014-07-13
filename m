Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752100AbaGMVH2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 17:07:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42041 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751747AbaGMVHU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 17:07:20 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <53BEA780.5050602@samsung.com>
References: <53BEA780.5050602@samsung.com> <1404924054.14643.36.camel@dhcp-9-2-203-236.watson.ibm.com> <1403620852-16476-1-git-send-email-zohar@linux.vnet.ibm.com> <24144.1404919879@warthog.procyon.org.uk> <8975.1404932208@warthog.procyon.org.uk> <1404941347.14643.57.camel@dhcp-9-2-203-236.watson.ibm.com>
To: Dmitry Kasatkin <d.kasatkin@samsung.com>
Cc: dhowells@redhat.com, Mimi Zohar <zohar@linux.vnet.ibm.com>,
        keyrings <keyrings@linux-nfs.org>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Josh Boyer <jwboyer@redhat.com>, Matthew Garrett <mjg59@srcf.ucam.org>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
Subject: Re: [PATCH v6 0/6] ima: extending secure boot certificate chain of trust
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <487.1405285619.1@warthog.procyon.org.uk>
Date: Sun, 13 Jul 2014 22:06:59 +0100
Message-ID: <488.1405285619@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Kasatkin <d.kasatkin@samsung.com> wrote:

> If patches from integrity/next-trusted-keys goes via your tree, then I
> suggest that you re-base your patches on the top of our
> patchset, because it is unclear how long review of PE, PKCS7 patches
> will take and if they will be pulled...

I'd rather not do that since other things are now depending on my patches.

What's probably better is just to clean up the duplication later.  That way,
there need be no dependency between the two sets.

David
