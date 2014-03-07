Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751683AbaCGDig (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 22:38:36 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:57831 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003AbaCGDie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 22:38:34 -0500
MIME-Version: 1.0
In-Reply-To: <53188E50.70808@gmail.com>
References: <53022DB1.4070805@gmail.com> <CA+55aFxjAp23=ySEe8e8bTPbVw8Uh8d03zirg4TdHXGYiyjmwA@mail.gmail.com>
 <CA+55aFy4GvpFcboBiKdreU_Zh1RzynPoLxhvC9hijn60hkEZ3g@mail.gmail.com> <53188E50.70808@gmail.com>
From: Yongzhi Pan <panyongzhi@gmail.com>
Date: Fri, 7 Mar 2014 11:38:14 +0800
Message-ID: <CACu+fTYSsmAMiV8w=BzYLEbf2WtiRO78=cy_G+1e5sk0p46vKg@mail.gmail.com>
Subject: Re: Update of file offset on write() etc. is non-atomic with I/O
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>, "Theodore T'so" <tytso@mit.edu>,
        Christoph Hellwig <hch@lst.de>, Chris Mason <clm@fb.com>,
        Dave Chinner <david@fromorbit.com>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "J. Bruce Fields" <bfields@citi.umich.edu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-03-06 23:03 GMT+08:00 Michael Kerrisk (man-pages) <mtk.manpages@gmail.com>:
>
> The original code (where Yongzhi Pan reported an issue) and
> the multi_writer.c test code where both mine actually. Anyway,
> I applied the patch to 3.14-rc5, and I (not withstanding the other
> points raised by Al about the patch) I confirm that this patch makes
> the  problem that I'm seeing go away.
>
> Thanks for looking at this, Linus.
>
> Cheers,
>
> Michael


I tested the original patch on 3.13.5, the multi_writer.c test code
and the code in your book both run flawlessly.


Best Regards,
Yongzhi Pan
