Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753084Ab3AVB3t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 20:29:49 -0500
Received: from ozlabs.org ([203.10.76.45]:54021 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752162Ab3AVB3r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 20:29:47 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Wanlong Gao <gaowanlong@cn.fujitsu.com>, linux-kernel@vger.kernel.org
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
        Eric Dumazet <erdnetdev@gmail.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Wanlong Gao <gaowanlong@cn.fujitsu.com>
Subject: Re: [PATCH V6 1/3] virtio-net: fix the set affinity bug when CPU IDs are not consecutive
In-Reply-To: <1358767524-17934-1-git-send-email-gaowanlong@cn.fujitsu.com>
References: <1358767524-17934-1-git-send-email-gaowanlong@cn.fujitsu.com>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Tue, 22 Jan 2013 11:42:40 +1030
Message-ID: <87hamavx4n.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wanlong Gao <gaowanlong@cn.fujitsu.com> writes:

> As Michael mentioned, set affinity and select queue will not work very
> well when CPU IDs are not consecutive, this can happen with hot unplug.
> Fix this bug by traversal the online CPUs, and create a per cpu variable
> to find the mapping from CPU to the preferable virtual-queue.

This series looks fairly sane at a glance, to me, but MST is the Ack you
need.

Thanks,
Rusty.
