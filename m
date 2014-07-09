Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756786AbaGIS5F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 14:57:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27499 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752746AbaGIS5C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 14:57:02 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1404924054.14643.36.camel@dhcp-9-2-203-236.watson.ibm.com>
References: <1404924054.14643.36.camel@dhcp-9-2-203-236.watson.ibm.com> <1403620852-16476-1-git-send-email-zohar@linux.vnet.ibm.com> <24144.1404919879@warthog.procyon.org.uk>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: dhowells@redhat.com, keyrings <keyrings@linux-nfs.org>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Josh Boyer <jwboyer@redhat.com>, Matthew Garrett <mjg59@srcf.ucam.org>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
Subject: Re: [PATCH v6 0/6] ima: extending secure boot certificate chain of trust
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <8974.1404932208.1@warthog.procyon.org.uk>
Date: Wed, 09 Jul 2014 19:56:48 +0100
Message-ID: <8975.1404932208@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:

> Yes, that's fine.  My concern, however, is that the trusted keyring
> patches are independent of the other patches being upstreamed and should
> be upstreamed regardless of the other patches.

There is overlap in the X.509 certificate request function that you took from
my pkcs#7 patches.

David
