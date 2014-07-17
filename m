Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754720AbaGQTn4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 15:43:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43378 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752604AbaGQTnz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 15:43:55 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1405516544.1466.50.camel@dhcp-9-2-203-236.watson.ibm.com>
References: <1405516544.1466.50.camel@dhcp-9-2-203-236.watson.ibm.com> <53BEA780.5050602@samsung.com> <1404924054.14643.36.camel@dhcp-9-2-203-236.watson.ibm.com> <1403620852-16476-1-git-send-email-zohar@linux.vnet.ibm.com> <24144.1404919879@warthog.procyon.org.uk> <8975.1404932208@warthog.procyon.org.uk> <1404941347.14643.57.camel@dhcp-9-2-203-236.watson.ibm.com> <488.1405285619@warthog.procyon.org.uk>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: dhowells@redhat.com, Dmitry Kasatkin <d.kasatkin@samsung.com>,
        keyrings <keyrings@linux-nfs.org>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Josh Boyer <jwboyer@redhat.com>, Matthew Garrett <mjg59@srcf.ucam.org>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
Subject: Re: [PATCH v6 0/6] ima: extending secure boot certificate chain of trust
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <8820.1405626206.1@warthog.procyon.org.uk>
Date: Thu, 17 Jul 2014 20:43:26 +0100
Message-ID: <8821.1405626206@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:

> We're already at -rc5.  Any pull requests for the next open window need
> to submitted soon.  If/when are you planning on sending James the pull
> request?  (I'm kind of waiting for the KEY patches to make it in, before
> sending the linux-integrity pull request.)

Just merging it all together now on top of the same base as yours.  Is
next-with-keys the branch I should be merging?

David
