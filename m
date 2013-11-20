Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754389Ab3KTQfM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 11:35:12 -0500
Received: from mail-vc0-f170.google.com ([209.85.220.170]:39923 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754392Ab3KTQfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 11:35:06 -0500
MIME-Version: 1.0
In-Reply-To: <1384952512-21600-5-git-send-email-miklos@szeredi.hu>
References: <1384952512-21600-1-git-send-email-miklos@szeredi.hu> <1384952512-21600-5-git-send-email-miklos@szeredi.hu>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 20 Nov 2013 08:34:45 -0800
Message-ID: <CALCETrXwuMRuxZe_tbSSYR0tC5afQQyR0YZXMJ6rUDXwd4CHgw@mail.gmail.com>
Subject: Re: [PATCH 04/11] vfs: add renameat2 syscall
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>, Zach Brown <zab@redhat.com>,
        Jan Kara <jack@suse.cz>, mszeredi@suse.cz
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 20, 2013 at 5:01 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
>
> Add new renameat2 syscall, which is the same as renameat with an added
> flags argument.

FWIW, I like this interface.

--Andy
