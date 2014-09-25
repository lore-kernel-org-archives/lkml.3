Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753414AbaIYOtD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 10:49:03 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:62090 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752854AbaIYOtA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 10:49:00 -0400
MIME-Version: 1.0
In-Reply-To: <1411652495-100852-1-git-send-email-oscar@oscr.io>
References: <1411652495-100852-1-git-send-email-oscar@oscr.io>
Date: Thu, 25 Sep 2014 16:48:59 +0200
Message-ID: <CAH6sp9NqiNincavwB9bQ94EvG8ZjvUPLH5u3j04OV2JMz7wTEg@mail.gmail.com>
Subject: Re: [PATCH 1/1] Changed "&" with "and" in Documentation/applying-patches.txt.
From: Frans Klaver <fransklaver@gmail.com>
To: oscar@oscr.io
Cc: Randy Dunlap <rdunlap@infradead.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2014 at 3:41 PM,  <oscar@oscr.io> wrote:
> Subject: [PATCH 1/1] Changed "&" with "and" in Documentation/applying-patches.txt.

Documentation/SubmittingPatches says:

Describe your changes in imperative mood, e.g. "make xyzzy do frotz"
instead of "[This patch] makes xyzzy do frotz" or "[I] changed xyzzy
to do frotz", as if you are giving orders to the codebase to change
its behaviour.

> From: Oscar Utbult <oscar@oscr.io>
>
> http://english.stackexchange.com/questions/3127/when-to-use-instead-of-and

It might be that a link is enough, but I would prefer to have an
excerpt from that, possibly with the link as reference.

Thanks,
Frans

>
> Signed-off-by: Oscar Utbult <oscar@oscr.io>
> ---
>  Documentation/applying-patches.txt | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/Documentation/applying-patches.txt b/Documentation/applying-patches.txt
> index a083ba3..77df55b 100644
> --- a/Documentation/applying-patches.txt
> +++ b/Documentation/applying-patches.txt
> @@ -94,7 +94,7 @@ Common errors when patching
>  ---
>   When patch applies a patch file it attempts to verify the sanity of the
>  file in different ways.
> -Checking that the file looks like a valid patch file & checking the code
> +Checking that the file looks like a valid patch file and checking the code
>  around the bits being modified matches the context provided in the patch are
>  just two of the basic sanity checks patch does.
>
> --
> 1.8.0.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
