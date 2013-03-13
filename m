Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756008Ab3CMJ54 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 05:57:56 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:33078 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754570Ab3CMJ5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 05:57:55 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <16729.1363108768@warthog.procyon.org.uk>
References: <CA+icZUUqSCZeb2JOFv-OSRXAQyD+crvGqg9E0FAUF=+ZAg5vFA@mail.gmail.com>
	<16729.1363108768@warthog.procyon.org.uk>
Date: Wed, 13 Mar 2013 10:57:53 +0100
Message-ID: <CA+icZUVj4jChaGSdC5Lu4R9h-NzVx8HqT+tnve9GOMh84C5sVw@mail.gmail.com>
Subject: Re: Status of union-mount?
From: Sedat Dilek <sedat.dilek@gmail.com>
To: David Howells <dhowells@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 12, 2013 at 6:19 PM, David Howells <dhowells@redhat.com> wrote:
> Sedat Dilek <sedat.dilek@gmail.com> wrote:
>
>> what's the status of union-mount?
>
> It's being reengineered again to take account of VFS changes that went in in
> the last merge window.
>

Hmmm, sorry for asking, but when do you plan to offer a "working"
union-mount (u-m)?
What's the status of the user-space tools or are they no more needed?
AFAICS the original authors patched e2fsprogs etc. (see Valerie's old
homepage [1]).

>> Where does the development happen - in [1]?
>
> On a git tree on my PC - which is occasionally mirrored in [1] when I've got
> it working.
>

Development on your local workstation does not look like you do an
open development.
So, it's currently only you doing the work on u-m?

- Sedat -

[1] http://valerieaurora.org/union/

> David
