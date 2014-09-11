Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752648AbaIKV1N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 17:27:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14129 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751666AbaIKV1M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 17:27:12 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1410443212.5187.59.camel@dhcp-9-2-203-236.watson.ibm.com>
References: <1410443212.5187.59.camel@dhcp-9-2-203-236.watson.ibm.com> <20140910212154.10752.23343.stgit@warthog.procyon.org.uk> <20140910212206.10752.21818.stgit@warthog.procyon.org.uk> <1410392204.5187.14.camel@dhcp-9-2-203-236.watson.ibm.com> <1410435813.5187.36.camel@dhcp-9-2-203-236.watson.ibm.com> <27732.1410437386@warthog.procyon.org.uk> <CACE9dm-4tURS7ZvJ45W81L5d3yaO8VDyvrcn1-SU_6UsHkmuQw@mail.gmail.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: dhowells@redhat.com, Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        James Morris <jmorris@namei.org>, keyrings <keyrings@linux-nfs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 2/6] KEYS: Reinstate EPERM for a key type name beginning with a '.'
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <11931.1410470812.1@warthog.procyon.org.uk>
Date: Thu, 11 Sep 2014 22:26:52 +0100
Message-ID: <11932.1410470812@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:

> The concept of dot prefixing should probably be documented either in the
> code and/or documentation.  At this point, both types and keyring names
> are reserved.

Indeed.  There is one type whose name begins with a '.' that's sort of
internal to the kernel (".request_key_auth") that I definitely don't want
userspace to try creating.

The question of whether the description of a non-keyring key is permitted to
begin with a '.' is a separate issue to this patch.  We'd have to be sure that
no one is using keys of such a form.

David
