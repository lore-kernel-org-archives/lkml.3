Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753575AbaKXPOc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 10:14:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53173 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753145AbaKXPOa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 10:14:30 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1416841165.25352.42.camel@dhcp-9-2-203-236.watson.ibm.com>
References: <1416841165.25352.42.camel@dhcp-9-2-203-236.watson.ibm.com> <1416836587.25352.24.camel@dhcp-9-2-203-236.watson.ibm.com> <1416829928.25352.6.camel@dhcp-9-2-203-236.watson.ibm.com> <20141120165351.5264.61930.stgit@warthog.procyon.org.uk> <20141120165425.5264.24661.stgit@warthog.procyon.org.uk> <14157.1416833305@warthog.procyon.org.uk> <26417.1416840116@warthog.procyon.org.uk>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: dhowells@redhat.com, mmarek@suse.cz, d.kasatkin@samsung.com,
        rusty@rustcorp.com.au, vgoyal@redhat.com, keyrings@linux-nfs.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] PKCS#7: Allow detached data to be supplied for signature checking purposes
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <27594.1416842053.1@warthog.procyon.org.uk>
Date: Mon, 24 Nov 2014 15:14:13 +0000
Message-ID: <27595.1416842053@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:

> No, it was more a comment on the function name
> pkcs7_supply_detached_data() being a bit weird, as the signature is
> appended to the data.

>From the point of view of the PKCS#7 message it's detached.

David
