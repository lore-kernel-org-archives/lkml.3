Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517AbaIALa5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 07:30:57 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:61795 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753368AbaIALa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 07:30:56 -0400
MIME-Version: 1.0
In-Reply-To: <1409508006-13136-1-git-send-email-bobby.prani@gmail.com>
References: <1409508006-13136-1-git-send-email-bobby.prani@gmail.com>
Date: Mon, 1 Sep 2014 13:30:55 +0200
Message-ID: <CANq1E4S+neOh0pQgvrN658iCe9Kmdpv0P9V2HTvrxxy3n+yGVQ@mail.gmail.com>
Subject: Re: [PATCH] memfd_test: Add missing argument to printf()
From: David Herrmann <dh.herrmann@gmail.com>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Sun, Aug 31, 2014 at 8:00 PM, Pranith Kumar <bobby.prani@gmail.com> wrote:
> Add a missing path argument buf to printf()
>
> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>

Looks good:

Reviewed-by: David Herrmann <dh.herrmann@gmail.com>

Thanks
David

> ---
>  tools/testing/selftests/memfd/memfd_test.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/memfd/memfd_test.c b/tools/testing/selftests/memfd/memfd_test.c
> index 3634c90..c343df8 100644
> --- a/tools/testing/selftests/memfd/memfd_test.c
> +++ b/tools/testing/selftests/memfd/memfd_test.c
> @@ -205,7 +205,7 @@ static void mfd_fail_open(int fd, int flags, mode_t mode)
>         sprintf(buf, "/proc/self/fd/%d", fd);
>         r = open(buf, flags, mode);
>         if (r >= 0) {
> -               printf("open(%s) didn't fail as expected\n");
> +               printf("open(%s) didn't fail as expected\n", buf);
>                 abort();
>         }
>  }
> --
> 2.1.0
>
