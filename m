Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757191AbaGVWRJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 18:17:09 -0400
Received: from mail-ig0-f179.google.com ([209.85.213.179]:41438 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756898AbaGVWRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 18:17:07 -0400
Date: Tue, 22 Jul 2014 15:17:05 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Madhavan Srinivasan <maddy@linux.vnet.ibm.com>
cc: arnd@arndb.de, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cleanup include/asm-generic/atomic.h
In-Reply-To: <53CDE123.6040100@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.2.02.1407221515010.5814@chino.kir.corp.google.com>
References: <1405985437-16631-1-git-send-email-maddy@linux.vnet.ibm.com> <alpine.DEB.2.02.1407211707510.5825@chino.kir.corp.google.com> <53CDE123.6040100@linux.vnet.ibm.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Jul 2014, Madhavan Srinivasan wrote:

> On Tuesday 22 July 2014 05:38 AM, David Rientjes wrote:
> > On Tue, 22 Jul 2014, Madhavan Srinivasan wrote:
> > 
> >> Commit 4b358e2206 "cleanup include/asm-generic/atomic.h" added
> >> comments for #else/#endif, but ended up adding same comment
> >> "BITS_PER_LONG == 64" on both sides. This patch fixes it.
> >>
> > 
> > It's intentionally like that, it comments the condition for which the 
> > #endif is matched.
> 
> Ok, will change the else comment. And include/asm-generic/local64.h
> also needs a change in comment.
> 

The #else comment is fine, it's correct as written.  The only use of these 
comments is to identify for the reader the #ifdef for which it is matched 
when there at least one nested #ifdef.
