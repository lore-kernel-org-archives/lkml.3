Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693Ab3BUG4G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 01:56:06 -0500
Received: from ozlabs.org ([203.10.76.45]:42891 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752554Ab3BUG4E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 01:56:04 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Asias He <asias@redhat.com>, Wanlong Gao <gaowanlong@cn.fujitsu.com>
Cc: pbonzini@redhat.com, mst@redhat.com, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 17/16 V2] virtio-scsi: use virtqueue_add_sgs for command buffers
In-Reply-To: <5124BEE8.9010006@redhat.com>
References: <1361260594-601-1-git-send-email-rusty@rustcorp.com.au> <1361353639-10623-1-git-send-email-gaowanlong@cn.fujitsu.com> <5124BEE8.9010006@redhat.com>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Thu, 21 Feb 2013 17:04:28 +1030
Message-ID: <874nh6gop7.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Asias He <asias@redhat.com> writes:
> On 02/20/2013 05:47 PM, Wanlong Gao wrote:
>> Using the new virtqueue_add_sgs function lets us simplify the queueing
>> path.  In particular, all data protected by the tgt_lock is just gone
>> (multiqueue will find a new use for the lock).
>> 
>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>> Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
>
> Reviewed-by: Asias He <asias@redhat.com>

Applied.

Unfortunately these won't be in until *next* merge window...

Cheers,
Rusty.
