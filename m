Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760092Ab3CHAdq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 19:33:46 -0500
Received: from ozlabs.org ([203.10.76.45]:58992 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758343Ab3CHAdo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 19:33:44 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Asias He <asias@redhat.com>,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH dontapply 0/2] tools/virtio updates for API testing
In-Reply-To: <cover.1361743821.git.mst@redhat.com>
References: <cover.1361743821.git.mst@redhat.com>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Fri, 08 Mar 2013 11:29:50 +1100
Message-ID: <87k3piwx6p.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Michael S. Tsirkin" <mst@redhat.com> writes:
> Here's a patchset to update tools/virtio with
> changes in 3.8, as well as the proposed API extension.
>
> Useful to see whether the extra level of indirection
> adds measureable overhead.
>
> I will upstream at least patch 1 soon.

What happened to this, BTW?

> Michael S. Tsirkin (2):
>   tools/virtio: fix build for 3.8

Thanks,
Rusty.
