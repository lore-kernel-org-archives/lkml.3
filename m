Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756205AbaGVQrF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 12:47:05 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:37098 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754581AbaGVQrC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 12:47:02 -0400
MIME-Version: 1.0
In-Reply-To: <20140722162455.GA15053@infradead.org>
References: <20140716114136.GA25237@infradead.org>
	<20140722162455.GA15053@infradead.org>
Date: Tue, 22 Jul 2014 18:47:00 +0200
Message-ID: <CAFLxGvwCysy9DGcUTzzcka87FX3j06fAhHH+vtJZiQcM4qNs7A@mail.gmail.com>
Subject: Re: VFS tree for 3.17?
From: Richard Weinberger <richard.weinberger@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 6:24 PM, Christoph Hellwig <hch@infradead.org> wrote:
> On Wed, Jul 16, 2014 at 04:41:36AM -0700, Christoph Hellwig wrote:
>> Hi Al,
>>
>> Do you plan to put a VFS tree together for 3.17?  To me the various
>> renameat2 bits from Miklos are something I'd really prefer to not miss,
>> but there might be other bits waiting for attention as well.
>
> Another weeks has passed and I'd really like to make sure we don't
> let the VFS leap.
>
> I'll try to put together a tree over the next days so we can at least
> get a minium amount of linux-next exposure.  Candidates are:
>
>  - the direct-io.c warning fix from Boaz (really should 3.16 actually)
>  - the unmount on symlink reference count fix

This fix is also stable material.
The issue as introduced in 3.12 by 8033426e6b
(vfs: allow umount to handle mountpoints without revalidating them)

>  - the rename/rename2 patches from Mikilos.  These are a bit older
>    and could use a respin.
>
> Anything else I've missed?
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Thanks,
//richard
