Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758688Ab3CHBJ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 20:09:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43606 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752893Ab3CHBJZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 20:09:25 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20130307232453.GD10304@kroah.com>
References: <20130307232453.GD10304@kroah.com> <1362669973-26984-1-git-send-email-acking@vmware.com> <26621.1362675490@warthog.procyon.org.uk>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: dhowells@redhat.com, Andy King <acking@vmware.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, davem@davemloft.net,
        pv-drivers@vmware.com
Subject: Re: [PATCH] VSOCK: Split vm_sockets.h into kernel/uapi
Date: Fri, 08 Mar 2013 01:09:18 +0000
Message-ID: <29364.1362704958@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <gregkh@linuxfoundation.org> wrote:

> David, is there any rush to get stuff like this into 3.9 for any
> uapi-type changes, or can it just wait for 3.10?

Not especially.  It won't appear in userspace due to the __KERNEL__ guards.

David
