Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755271AbaITMIl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 08:08:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56336 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754082AbaITMIj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 08:08:39 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <alpine.LRH.2.11.1409201204460.31120@namei.org>
References: <alpine.LRH.2.11.1409201204460.31120@namei.org> <32370.1410886755@warthog.procyon.org.uk>
To: James Morris <jmorris@namei.org>
Cc: dhowells@redhat.com, keyrings@linux-nfs.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] KEYS: Changes for keyrings for security/next
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <7791.1411214905.1@warthog.procyon.org.uk>
Date: Sat, 20 Sep 2014 13:08:25 +0100
Message-ID: <7792.1411214905@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Morris <jmorris@namei.org> wrote:

> I'm getting this warning after pulling your code:
> 
>   CC      crypto/hash_info.o
> crypto/asymmetric_keys/asymmetric_type.c: In function 
> asymmetric_key_hex_to_key_id:
> crypto/asymmetric_keys/asymmetric_type.c:110: warning: ignoring return 
> value of hex2bin, declared with attribute warn_unused_result

I don't see that with my compiler for some reason.  I'm not sure what to do
about it even so.  I don't need to check the result of hex2bin because I've
done all the checks required before allocating the buffer for hex2bin to write
into.  I could remove the attribute from hex2bin(), I suppose.

David
