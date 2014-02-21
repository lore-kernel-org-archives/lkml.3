Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036AbaBUNII (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 08:08:08 -0500
Received: from mail-ve0-f177.google.com ([209.85.128.177]:56391 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755969AbaBUNIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 08:08:05 -0500
MIME-Version: 1.0
In-Reply-To: <53073B1A.3040709@gmail.com>
References: <53073B1A.3040709@gmail.com>
Date: Fri, 21 Feb 2014 14:08:03 +0100
Message-ID: <CAFLxGvygOyXrMt=UBnMUziVFG40sEQvRquGKV8kyrhdp-_NrgQ@mail.gmail.com>
Subject: Re: BUG: unable to handle kernel paging request at 0000000100000003 -
 Oops: 0000 [#1] SMP
From: Richard Weinberger <richard.weinberger@gmail.com>
To: poma <pomidorabelisima@gmail.com>
Cc: Mailing-List fedora-kernel <kernel@lists.fedoraproject.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Josh Boyer <jwboyer@redhat.com>,
        "Justin M. Forbes" <jforbes@redhat.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
        Dave Jones <davej@redhat.com>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@lst.de>, eparis@parisplace.org,
        Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 21, 2014 at 12:40 PM, poma <pomidorabelisima@gmail.com> wrote:
>
> Affected kernels - 3.14.0-0.rc3*:
>
> - 3.14.0-0.rc3.git0.1
>   http://koji.fedoraproject.org/koji/buildinfo?buildID=498711
>
> - 3.14.0-0.rc3.git0.7 based on 3.14.0-0.rc3.git0.1
>
> - 3.14.0-0.rc3.git2.1
>   http://koji.fedoraproject.org/koji/buildinfo?buildID=499061
>
> - 3.14.0-0.rc3.git5.1
>   http://koji.fedoraproject.org/koji/buildinfo?buildID=499636
>
> Memtest86+ 4.20 - OK
> http://goo.gl/1nm1nV
>
> RHBZ
> https://bugzilla.redhat.com/show_bug.cgi?id=1067919
>
> messages-Oops-es-3.14.0-0.rc3
> https://bugzilla.redhat.com/attachment.cgi?id=865926

Maybe commits 7053aee26a3548ebaba046ae2e52396ccf56ac6c (fsnotify: do
not share events between notification groups)
and 85816794240b9659e66e4d9b0df7c6e814e5f603 (fanotify: Fix use after
free for permission events) introduced this regression.

CC'ing more guys.

-- 
Thanks,
//richard
