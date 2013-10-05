Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752299Ab3JEALo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 20:11:44 -0400
Received: from mail-ve0-f178.google.com ([209.85.128.178]:41650 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330Ab3JEALm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 20:11:42 -0400
MIME-Version: 1.0
In-Reply-To: <524F5625.4080807@mit.edu>
References: <1380643239-16060-1-git-send-email-miklos@szeredi.hu>
	<524F5625.4080807@mit.edu>
Date: Fri, 4 Oct 2013 17:11:41 -0700
X-Google-Sender-Auth: YutssokAJAKzkFpM1cf17olzl5g
Message-ID: <CA+55aFypLwaOAEiVV2nChiCvNh7-wysOUTheFU-RcWJ1m57wnQ@mail.gmail.com>
Subject: Re: [RFC PATCH 0/7] cross rename
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>, "zab@redhat.com" <zab@redhat.com>,
        Jan Kara <jack@suse.cz>, "Theodore Ts'o" <tytso@mit.edu>,
        Miklos Szeredi <mszeredi@suse.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 4, 2013 at 4:58 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>
> How hard would it be to also add RENAME_NOREPLACE that fails if the
> destination already exists?

Trivial. And I agree that that should be a good flag to have.

               Linus
