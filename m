Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752756AbaILVOh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 17:14:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26260 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752365AbaILVOf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 17:14:35 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1410555196.5187.223.camel@dhcp-9-2-203-236.watson.ibm.com>
References: <1410555196.5187.223.camel@dhcp-9-2-203-236.watson.ibm.com> <1410552676.5187.211.camel@dhcp-9-2-203-236.watson.ibm.com> <20140912190510.13239.90409.stgit@warthog.procyon.org.uk> <20140912190515.13239.89507.stgit@warthog.procyon.org.uk> <28503.1410553800@warthog.procyon.org.uk>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: dhowells@redhat.com, vgoyal@redhat.com, keyrings@linux-nfs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Keyrings] [PATCH 1/9] Provide a binary to hex conversion function
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <29282.1410556467.1@warthog.procyon.org.uk>
Date: Fri, 12 Sep 2014 22:14:27 +0100
Message-ID: <29283.1410556467@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:

> I'm suggesting making bin2hex() a wrapper for calling hex_byte_pack().

Done.

David
