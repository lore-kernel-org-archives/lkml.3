Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753999AbaGIAhC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 20:37:02 -0400
Received: from ozlabs.org ([103.22.144.67]:34237 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751150AbaGIAfl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 20:35:41 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>
Cc: Ming Lei <ming.lei@canonical.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-api@vger.kernel.org,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v3 0/2] block: virtio-blk: support multi vq per virtio-blk
In-Reply-To: <20140701081311.GA21973@infradead.org>
References: <1403775708-22244-1-git-send-email-ming.lei@canonical.com> <CACVXFVMHPdEzai32jRmLt7qGMFcUqFb8OunF0tzySpKoLWWiwQ@mail.gmail.com> <CACVXFVMb4UXRYSp6nvjDQrDRcLP6rJ3_3QHYMzKv9MoogsU66w@mail.gmail.com> <53B22473.8010709@kernel.dk> <20140701081311.GA21973@infradead.org>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Wed, 09 Jul 2014 09:37:02 +0930
Message-ID: <8761j775uh.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig <hch@infradead.org> writes:
> On Mon, Jun 30, 2014 at 09:01:07PM -0600, Jens Axboe wrote:
>> >I appreciate very much that one of you may queue these two
>> >patches into your tree so that userspace work can be kicked off,
>> >since Michael has acked both patches and all comments have
>> >been addressed already.
>> 
>> Given that Michael also acked it and Rusty is on his sabbatical, I'll queue
>> it up for 3.17.
>
> So Rusty is offline?  Who is taking care of module/moduleparam patches
> in the meantime?

I'm intermittantly online :)

Cheers,
Rusty.
