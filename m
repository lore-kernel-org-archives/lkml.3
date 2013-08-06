Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756722Ab3HFSgq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 14:36:46 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:58750 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756515Ab3HFSgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 14:36:45 -0400
MIME-Version: 1.0
In-Reply-To: <5200AD26.8070701@asianux.com>
References: <5200AD26.8070701@asianux.com>
Date: Tue, 6 Aug 2013 11:36:44 -0700
X-Google-Sender-Auth: 0zWWFzygfqzbyijerUrjyQH6VGE
Message-ID: <CAGXu5j+J=y-+wnkXV_wLJnoCOupFGk8GwvHjJz2oWCiZt_oQGQ@mail.gmail.com>
Subject: Re: [PATCH 0/2] kernel/sys.c: for setfsgid(), return the current gid
 when error occurs
From: Kees Cook <keescook@chromium.org>
To: Chen Gang <gang.chen@asianux.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Oleg Nesterov <oleg@redhat.com>,
        Robin Holt <holt@sgi.com>, Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 6, 2013 at 1:00 AM, Chen Gang <gang.chen@asianux.com> wrote:
> They are 2 related patches for setfsgid().
>
> Patch 1 for bug fix: return the current gid when error occurs.
> Patch 2 for cleaning code: remove useless variable 'old_fsgid'.
>
> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> --
>  kernel/sys.c |   15 +++++----------
>  1 files changed, 5 insertions(+), 10 deletions(-)

Making a change like this might have dramatic effects. So, a few
questions, to help better understand:

How long as the behavior been this way on Linux?
What is the origin of the documentation that states it differently?
Do existing userspace tools already depend on the current behavior?
What specific problem will be solved by changing this?

Thanks,

-Kees

-- 
Kees Cook
Chrome OS Security
