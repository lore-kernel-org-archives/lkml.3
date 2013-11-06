Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755101Ab3KFQBU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 11:01:20 -0500
Received: from services.gouders.net ([141.101.32.176]:46609 "EHLO
	services.gouders.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754529Ab3KFQBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 11:01:19 -0500
From: Dirk Gouders <dirk@gouders.net>
To: Joe Perches <joe@perches.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC trivial] printk.c: /proc/vmcore instead of /proc/vmcoreinfo in comments?
In-Reply-To: <1382457444.2041.82.camel@joe-AO722> (Joe Perches's message of
	"Tue, 22 Oct 2013 08:57:24 -0700")
References: <gik3h5tsbn.fsf@karga.hank.lab>
	<1382457444.2041.82.camel@joe-AO722>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
Date: Wed, 06 Nov 2013 17:01:31 +0100
Message-ID: <gh8ux17c4k.fsf@lena.gouders.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches <joe@perches.com> writes:

> On Tue, 2013-10-22 at 14:15 +0200, Dirk Gouders wrote:
>> Hello Joe,
>> 
>> when having a look at printk.c, I noticed that two comments refer
>> to /proc/vmcoreinfo and I wonder if that should not read /proc/vmcore.
>> 
>> While at it, a typo in one of those coments could also be fixed.
>
> Hi Dirk.
>
> Thanks and yes this is sensible.
> Adding Andrew Morton to cc's and resending as plain-text

Hi Joe and Andrew,

thank you for reviewing and accepting (indicated by another mail from
Andrew) this patch.

Dirk


> From 2ef84ff3187633a3156c3a967c1dfc294292e492 Mon Sep 17 00:00:00 2001
> From: Dirk Gouders <dirk@gouders.net>
> Date: Tue, 22 Oct 2013 13:51:15 +0200
> Subject: [PATCH] printk.c: comments should refer to /proc/vmcore instead of
>  /proc/vmcoreinfo
>
> In one of those comments a typo was fixed, too.
>
> Signed-off-by: Dirk Gouders <dirk@gouders.net>
> ---
>  kernel/printk/printk.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
> index b4e8500..694d1f9 100644
> --- a/kernel/printk/printk.c
> +++ b/kernel/printk/printk.c
> @@ -705,9 +705,9 @@ const struct file_operations kmsg_fops = {
>  
>  #ifdef CONFIG_KEXEC
>  /*
> - * This appends the listed symbols to /proc/vmcoreinfo
> + * This appends the listed symbols to /proc/vmcore
>   *
> - * /proc/vmcoreinfo is used by various utiilties, like crash and makedumpfile to
> + * /proc/vmcore is used by various utilities, like crash and makedumpfile to
>   * obtain access to symbols that are otherwise very difficult to locate.  These
>   * symbols are specifically used so that utilities can access and extract the
>   * dmesg log from a vmcore file after a crash.
