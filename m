Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751481AbaLaQFj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 11:05:39 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:42065 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143AbaLaQFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 11:05:37 -0500
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <1420040119-32669-2-git-send-email-mmarek@suse.cz>
References: <54A40743.8080401@suse.cz>
	<1420040119-32669-1-git-send-email-mmarek@suse.cz>
	<1420040119-32669-2-git-send-email-mmarek@suse.cz>
Date: Wed, 31 Dec 2014 17:05:35 +0100
Message-ID: <CA+icZUWns7H3MWpfNJADWse-RYD+pr4_FM=CA-ydXmwL7RZL+g@mail.gmail.com>
Subject: Re: [PATCH 2/2] kbuild: Drop support for clean-rule
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Michal Marek <mmarek@suse.cz>
Cc: Ben Hutchings <ben@decadent.org.uk>, max@stro.at,
        LKML <linux-kernel@vger.kernel.org>, linux-kbuild@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 31, 2014 at 4:35 PM, Michal Marek <mmarek@suse.cz> wrote:
> clean-rule has not been used since 94869f86 (kbuild: Accept absolute
> paths in clean-files and introduce clean-dirs) ten years ago.
>
> Signed-off-by: Michal Marek <mmarek@suse.cz>

Tested-by: Sedat Dilek <sedat.dilek@gmail.com>

- Sedat -

> ---
>  scripts/Makefile.clean | 3 ---
>  1 file changed, 3 deletions(-)
>
> diff --git a/scripts/Makefile.clean b/scripts/Makefile.clean
> index 627f8cb..55c96cb 100644
> --- a/scripts/Makefile.clean
> +++ b/scripts/Makefile.clean
> @@ -71,9 +71,6 @@ endif
>  ifneq ($(strip $(__clean-dirs)),)
>         +$(call cmd,cleandir)
>  endif
> -ifneq ($(strip $(clean-rule)),)
> -       +$(clean-rule)
> -endif
>         @:
>
>
> --
> 2.1.2
>
