Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756617Ab3CSCpR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 22:45:17 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:40077 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753439Ab3CSCpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 22:45:15 -0400
Date: Mon, 18 Mar 2013 19:41:21 -0700
From: Anton Vorontsov <anton@enomsg.org>
To: Kees Cook <keescook@chromium.org>
Cc: Alexandru Gheorghiu <gheorghiuandru@gmail.com>,
        Colin Cross <ccross@android.com>, Tony Luck <tony.luck@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fs: pstore: Replaced calls to kmalloc and memcpy with
 kmemdup
Message-ID: <20130319024121.GC14118@lizard.gateway.2wire.net>
References: <1362830248-7017-1-git-send-email-gheorghiuandru@gmail.com>
 <CAGXu5jLakegTD5KPmpJviWtRJ2UgRUX7v+q2+BrsGZknzOLA0Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAGXu5jLakegTD5KPmpJviWtRJ2UgRUX7v+q2+BrsGZknzOLA0Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 10, 2013 at 04:23:01PM -0700, Kees Cook wrote:
> On Sat, Mar 9, 2013 at 3:57 AM, Alexandru Gheorghiu
> <gheorghiuandru@gmail.com> wrote:
> > Replaced calls to kmalloc and memcpy with a single call to kmemdup.
> > This patch was found using coccicheck.
> >
> > Signed-off-by: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
[...]
> Looks fine to me. Thanks!
> 
> Acked-by: Kees Cook <keescook@chromium.org>

Applied to linux-pstore.git, thanks a lot!

Anton
