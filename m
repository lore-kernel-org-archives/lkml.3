Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401Ab3DBF60 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 01:58:26 -0400
Received: from ozlabs.org ([203.10.76.45]:39636 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754212Ab3DBF60 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 01:58:26 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Paul Bolle <pebolle@tiscali.nl>, "Michael S. Tsirkin" <mst@redhat.com>
Cc: virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/8] virtio: do not export "u16" and "u64" to userspace
In-Reply-To: <1364839156.21627.65.camel@x61.thuisdomein>
References: <1364839156.21627.65.camel@x61.thuisdomein>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Tue, 02 Apr 2013 09:59:54 +1030
Message-ID: <87y5d16d8t.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Bolle <pebolle@tiscali.nl> writes:
> virtio_balloon.h exports "u16" and "u64" to userspace. Use "__u16" and
> "__u64" instead.
>
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> 0) Tested with a kernel build.
>
> 1) Both types are used in this header for quite some time now. So is my
> patch flawed or doesn't userspace actually use virtio_balloon.h?

qemu rolls its own copy, but this is still a valid fix.

Thanks,
Rusty.
