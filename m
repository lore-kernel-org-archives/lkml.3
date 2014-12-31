Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751540AbaLaVxY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 16:53:24 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:20814 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080AbaLaVxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 16:53:23 -0500
Message-ID: <54A4703B.2000006@oracle.com>
Date: Wed, 31 Dec 2014 15:52:59 -0600
From: Dave Kleikamp <dave.kleikamp@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: sedat.dilek@gmail.com
CC: LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>,
        Zach Brown <zab@zabbo.net>, Ming Lei <ming.lei@canonical.com>
Subject: Re: [PATCH V8 00/33] loop: Issue O_DIRECT aio using bio_vec
References: <1374774659-13121-1-git-send-email-dave.kleikamp@oracle.com> <CA+icZUV17qR-kBRnYa+r0DfchQ0QtaBy-6c3f3QuXn0EGwuJzQ@mail.gmail.com>
In-Reply-To: <CA+icZUV17qR-kBRnYa+r0DfchQ0QtaBy-6c3f3QuXn0EGwuJzQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/31/2014 02:38 PM, Sedat Dilek wrote:
> 
> What has happened to that aio_loop patchset?
> Is it in Linux-next?
> ( /me started to play with "block: loop: convert to blk-mq (v3)", so I
> recalled this other improvement. )

It met with some harsh resistance, so I backed off on it. Then Al Viro
got busy re-writing the iov_iter infrastructure and I put my patchset on
the shelf to look at later. Then Ming Lei submitted more up-to-date
patchset: https://lkml.org/lkml/2014/8/6/175

It looks like Ming is currently only pushing the first half of that
patchset. I don't know what his plans are for the last three patches:

aio: add aio_kernel_() interface
fd/direct-io: introduce should_dirty for kernel aio
block: loop: support to submit I/O via kernel aio based

Dave
