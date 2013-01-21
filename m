Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752655Ab3AUAqM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 19:46:12 -0500
Received: from mail-vc0-f169.google.com ([209.85.220.169]:36121 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495Ab3AUAqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 19:46:10 -0500
MIME-Version: 1.0
In-Reply-To: <87zk03wg7r.fsf@rustcorp.com.au>
References: <87zk03wg7r.fsf@rustcorp.com.au>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 20 Jan 2013 16:45:49 -0800
X-Google-Sender-Auth: sR_s0skZB7XHLIo_wMNYXrr83uo
Message-ID: <CA+55aFwzdcv0LXovZobha=EH=L6DapJt+ODP0nq=TWWAqCxLYQ@mail.gmail.com>
Subject: Re: [PULL] Module fixes, and a virtio block fix.
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: LKML <linux-kernel@vger.kernel.org>, Alexander Graf <agraf@suse.de>,
        Prarit Bhargava <prarit@redhat.com>,
        Sasha Levin <sasha.levin@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 20, 2013 at 4:08 PM, Rusty Russell <rusty@rustcorp.com.au> wrote:
>
> are available in the git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux.git fixes

Ugh.

You *meant* the "fixes-for-linus" tag, not the "fixes" branch.

Either you mistyped, or you have one of the unfortunate old git
versions that silently "fixed" the branch name for you to the first
one it saw.

Either way, please fix for future pull requests...

            Linus
