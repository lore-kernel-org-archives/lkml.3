Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752646AbaILUxT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 16:53:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11079 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751143AbaILUxS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 16:53:18 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1410554830.9942.52.camel@joe-AO725>
References: <1410554830.9942.52.camel@joe-AO725> <1410552676.5187.211.camel@dhcp-9-2-203-236.watson.ibm.com> <20140912190510.13239.90409.stgit@warthog.procyon.org.uk> <20140912190515.13239.89507.stgit@warthog.procyon.org.uk> <28503.1410553800@warthog.procyon.org.uk>
To: Joe Perches <joe@perches.com>
Cc: dhowells@redhat.com, Mimi Zohar <zohar@linux.vnet.ibm.com>,
        vgoyal@redhat.com, keyrings@linux-nfs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Keyrings] [PATCH 1/9] Provide a binary to hex conversion function
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <28690.1410555188.1@warthog.procyon.org.uk>
Date: Fri, 12 Sep 2014 21:53:08 +0100
Message-ID: <28691.1410555188@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches <joe@perches.com> wrote:

> I think Mimi meant using something like:
> 
> char *bin2hex(char *dst, const void *src, size_t count)
> {
> 	const unsigned char *_src = src;
> 
> 	while (count--)
> 		dst = hex_byte_pack(dst, *_src++);
> 
> 	return dst;
> }

Ah, I see - yeah, that'd work.

David
