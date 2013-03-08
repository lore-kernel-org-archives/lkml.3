Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759922Ab3CHR0Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 12:26:16 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:56869 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757876Ab3CHR0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 12:26:12 -0500
Date: Fri, 08 Mar 2013 12:26:10 -0500 (EST)
Message-Id: <20130308.122610.415557290822516252.davem@davemloft.net>
To: dhowells@redhat.com
Cc: gregkh@linuxfoundation.org, acking@vmware.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, pv-drivers@vmware.com
Subject: Re: [PATCH] VSOCK: Split vm_sockets.h into kernel/uapi
From: David Miller <davem@davemloft.net>
In-Reply-To: <29364.1362704958@warthog.procyon.org.uk>
References: <1362669973-26984-1-git-send-email-acking@vmware.com>
	<26621.1362675490@warthog.procyon.org.uk>
	<29364.1362704958@warthog.procyon.org.uk>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Fri, 08 Mar 2013 09:26:16 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Howells <dhowells@redhat.com>
Date: Fri, 08 Mar 2013 01:09:18 +0000

> Greg KH <gregkh@linuxfoundation.org> wrote:
> 
>> David, is there any rush to get stuff like this into 3.9 for any
>> uapi-type changes, or can it just wait for 3.10?
> 
> Not especially.  It won't appear in userspace due to the __KERNEL__ guards.

I've applied this to net-next, thanks.
