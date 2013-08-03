Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752937Ab3HCT2w (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Aug 2013 15:28:52 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:52783 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752795Ab3HCT2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Aug 2013 15:28:51 -0400
MIME-Version: 1.0
In-Reply-To: <20130802192713.GA9543@redhat.com>
References: <20130802192713.GA9543@redhat.com>
Date: Sat, 3 Aug 2013 12:28:50 -0700
X-Google-Sender-Auth: HfZlBqtbh9ne911C0niuXpCFX7I
Message-ID: <CAGXu5jLCprSWpODu9cGbhLshUEguc6-0b4jRAZscVMJzt=CehQ@mail.gmail.com>
Subject: Re: [PATCH 0/5] exec: more cleanups
From: Kees Cook <keescook@chromium.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Zach Levis <zml@linux.vnet.ibm.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Evgeniy Polyakov <zbr@ioremap.net>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 2, 2013 at 12:27 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> On top of "[PATCH 0/3] exec: minor cleanups + minor fix" I sent
> yesterday.
>
> Perhaps too many patches for the poor search_binary_handler(),
> but I do not know how to document the changes if I join them.
>
> Oleg.
>
>  fs/exec.c |   82 ++++++++++++++++++++++++++----------------------------------
>  1 files changed, 36 insertions(+), 46 deletions(-)
>

This all looks really good. Thanks for the cleanups! Besides the one
comment on patch 1, consider the series:

Acked-by: Kees Cook <keescook@chromium.org>

Thanks,

-Kees

-- 
Kees Cook
Chrome OS Security
