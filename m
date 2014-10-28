Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753020AbaJ1Awp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 20:52:45 -0400
Received: from ozlabs.org ([103.22.144.67]:56546 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752566AbaJ1Awn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 20:52:43 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ming Lei <tom.leiming@gmail.com>, "Michael S. Tsirkin" <mst@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH] virtio_blk: fix race at module removal
In-Reply-To: <CACVXFVMP9yLfUhwh6MH=q6a11Z8AeJ8aso7R+LNb-QoDfD5UVw@mail.gmail.com>
References: <1414080703-4547-1-git-send-email-mst@redhat.com> <CACVXFVMP9yLfUhwh6MH=q6a11Z8AeJ8aso7R+LNb-QoDfD5UVw@mail.gmail.com>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Tue, 28 Oct 2014 10:55:04 +1030
Message-ID: <8761f5avmn.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ming Lei <tom.leiming@gmail.com> writes:
> On Fri, Oct 24, 2014 at 12:12 AM, Michael S. Tsirkin <mst@redhat.com> wrote:
>> If a device appears while module is being removed,
>> driver will get a callback after we've given up
>> on the major number.
>>
>> In theory this means this major number can get reused
>> by something else, resulting in a conflict.
>
> Yes, there is a tiny race window.

Applied.

Thanks,
Rusty.
