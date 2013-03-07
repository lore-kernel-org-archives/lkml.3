Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759010Ab3CGQ6S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 11:58:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26667 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754377Ab3CGQ6R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 11:58:17 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1362669973-26984-1-git-send-email-acking@vmware.com>
References: <1362669973-26984-1-git-send-email-acking@vmware.com>
To: Andy King <acking@vmware.com>
Cc: dhowells@redhat.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, gregkh@linuxfoundation.org,
        davem@davemloft.net, pv-drivers@vmware.com
Subject: Re: [PATCH] VSOCK: Split vm_sockets.h into kernel/uapi
Date: Thu, 07 Mar 2013 16:58:10 +0000
Message-ID: <26621.1362675490@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy King <acking@vmware.com> wrote:

> Split the vSockets header into kernel and UAPI parts.  The former gets the bits
> that used to be in __KERNEL__ guards, while the latter gets everything that is
> user-visible.  Tested by compiling vsock (+transport) and a simple user-mode
> vSockets application.
> 
> Reported-by: David Howells <dhowells@redhat.com>
> Acked-by: Dmitry Torokhov <dtor@vmware.com>
> Signed-off-by: Andy King <acking@vmware.com>

Acked-by: David Howells <dhowells@redhat.com>
