Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758764AbaGXLV0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 07:21:26 -0400
Received: from mail-qg0-f41.google.com ([209.85.192.41]:49747 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758612AbaGXLVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 07:21:23 -0400
MIME-Version: 1.0
X-Originating-IP: [46.139.80.5]
In-Reply-To: <alpine.LSU.2.11.1407240359360.1136@eggly.anvils>
References: <1406121336-1379-1-git-send-email-miklos@szeredi.hu>
	<1406121336-1379-5-git-send-email-miklos@szeredi.hu>
	<alpine.LSU.2.11.1407240359360.1136@eggly.anvils>
Date: Thu, 24 Jul 2014 13:21:22 +0200
Message-ID: <CAJfpegsi43F0B4hMmJ-HaQOfuHMnhz4uUTNDcORTKoH-QVwF3A@mail.gmail.com>
Subject: Re: [PATCH 4/7] shmem: support RENAME_NOREPLACE
From: Miklos Szeredi <miklos@szeredi.hu>
To: Hugh Dickins <hughd@google.com>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Miklos Szeredi <mszeredi@suse.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2014 at 1:08 PM, Hugh Dickins <hughd@google.com> wrote:
> On Wed, 23 Jul 2014, Miklos Szeredi wrote:
>> From: Miklos Szeredi <mszeredi@suse.cz>
>>
>> Expand noreplace_rename2() because next patch will implement one more flag.
>
> noreplace_rename2()??  I understand the code better than this comment.

Fixed, and acks added.  Thanks!

Miklos
