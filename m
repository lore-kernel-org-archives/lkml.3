Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754575AbaE3HAq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 03:00:46 -0400
Received: from ozlabs.org ([103.22.144.67]:47783 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751782AbaE3HAo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 03:00:44 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@canonical.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH] block: virtio_blk: don't hold spin lock during world switch
In-Reply-To: <5387FC96.4030508@kernel.dk>
References: <1401418169-3361-1-git-send-email-ming.lei@canonical.com> <5387F8B2.1070509@kernel.dk> <CACVXFVPoG6_fL_MTRF+616W7UdHpSgjtMLBLeBn4OGR63haw3w@mail.gmail.com> <5387FC96.4030508@kernel.dk>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Fri, 30 May 2014 15:40:02 +0930
Message-ID: <877g537q6d.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe <axboe@kernel.dk> writes:
> If Rusty agrees, I'd like to add it for 3.16 with a stable marker.

Really stable?  It improves performance, which is nice.  But every patch
which goes into the kernel fixes a bug, improves clarity, improves
performance or adds a feature.  I've now seen all four cases get CC'd
into stable.

Including some of mine explicitly not marked stable which get swept up
by enthusiastic stable maintainers :(

Is now there *any* patch short of a major rewrite which shouldn't get
cc: stable?

Cheers,
Rusty.
