Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752819AbaCXJrT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 05:47:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44572 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752781AbaCXJrQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 05:47:16 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1395640404-27958-1-git-send-email-behanw@converseincode.com>
References: <1395640404-27958-1-git-send-email-behanw@converseincode.com> <1395506558.2143.18.camel@dabdike.int.hansenpartnership.com>
To: behanw@converseincode.com
Cc: dhowells@redhat.com, arnd@arndb.de, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, dwmw2@infradead.org,
        pageexec@freemail.hu, Mark Charlebois <charlebm@gmail.com>
Subject: Re: [PATCH v4] LLVMLinux: Remove warning about returning an uninitialized variable
Date: Mon, 24 Mar 2014 09:46:32 +0000
Message-ID: <11930.1395654392@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

behanw@converseincode.com wrote:

> From: Behan Webster <behanw@converseincode.com>
> 
> Fix uninitialized return code in default case in cmpxchg-local.h
> 
> This patch fixes the code to prevent an uninitialized return value that is detected
> when compiling with clang. The bug produces numerous warnings when compiling the
> Linux kernel with clang.
> 
> Signed-off-by: Behan Webster <behanw@converseincode.com>
> Signed-off-by: Mark Charlebois <charlebm@gmail.com>

Acked-by: David Howells <dhowells@redhat.com>
