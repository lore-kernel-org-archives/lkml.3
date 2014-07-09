Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185AbaGIBNW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 21:13:22 -0400
Received: from ozlabs.org ([103.22.144.67]:55255 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752936AbaGIBNR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 21:13:17 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@canonical.com>,
        linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, virtualization@lists.linux-foundation.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 0/2] block: virtio-blk: support multi vq per virtio-blk
In-Reply-To: <53ABAA34.6070006@kernel.dk>
References: <1403748526-1923-1-git-send-email-ming.lei@canonical.com> <53ABAA34.6070006@kernel.dk>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Wed, 09 Jul 2014 10:31:08 +0930
Message-ID: <87ion75orv.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe <axboe@kernel.dk> writes:
> Rusty, do you want to ack this (and I'll slurp it up for 3.17) or take 
> this yourself? Or something else?

I'm happy with the idea, and importantly, the new feature bit.  So once
the implementation is tweaked, please add:

        Acked-by: Rusty Russell <rusty@rustcorp.com.au>

The new feature bit takes us outside the current standard (which is
hopefully now frozen), but I'll just add it to the pile of things to
revisit for 1.1.

Thanks,
Rusty,
