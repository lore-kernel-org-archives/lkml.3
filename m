Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754376Ab3GJD7N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 23:59:13 -0400
Received: from ozlabs.org ([203.10.76.45]:36170 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754140Ab3GJD7M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 23:59:12 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org
Cc: virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>
Subject: Re: [PATCH 1/2] virtio: support unlocked queue poll
In-Reply-To: <1373274069-4301-2-git-send-email-mst@redhat.com>
References: <1373274069-4301-1-git-send-email-mst@redhat.com> <1373274069-4301-2-git-send-email-mst@redhat.com>
User-Agent: Notmuch/0.15.2+81~gd2c8818 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Wed, 10 Jul 2013 12:39:58 +0930
Message-ID: <87k3kzcdq1.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Michael S. Tsirkin" <mst@redhat.com> writes:
> This adds a way to check ring empty state after enable_cb outside any
> locks. Will be used by virtio_net.
>
> Note: there's room for more optimization: caller is likely to have a
> memory barrier already, which means we might be able to get rid of a
> barrier here.  Deferring this optimization until we do some
> benchmarking.
>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

Acked-by: Rusty Russell <rusty@rustcorp.com.au>

Thanks,
Rusty.
