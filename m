Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757165Ab3BVUhh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 15:37:37 -0500
Received: from mail-da0-f52.google.com ([209.85.210.52]:43524 "EHLO
	mail-da0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756998Ab3BVUhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 15:37:32 -0500
Date: Fri, 22 Feb 2013 12:37:29 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: George Zhang <georgezhang@vmware.com>, Andy King <acking@vmware.com>,
        Dmitry Torokhov <dtor@vmware.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch] drivers, vmci: vmware vmci driver depends on
 CONFIG_NET
In-Reply-To: <alpine.DEB.2.02.1302211344180.28115@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.02.1302221236480.10081@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1302211344180.28115@chino.kir.corp.google.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Feb 2013, David Rientjes wrote:

> CONFIG_VMWARE_VMCI requires CONFIG_NET, otherwise there is a link error:
> 
> drivers/built-in.o: In function `__qp_memcpy_from_queue.isra.11':
> vmci_queue_pair.c:(.text+0x2d4509): undefined reference to `memcpy_toiovec'
> drivers/built-in.o: In function `__qp_memcpy_to_queue.isra.12':
> vmci_queue_pair.c:(.text+0x2d4709): undefined reference to `memcpy_fromiovec'
> 

This link error has made it to Linus' tree, so hopefully this can be 
merged and pushed before rc1.
