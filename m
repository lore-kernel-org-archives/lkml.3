Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755411AbaEIAZA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 20:25:00 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:35588 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754946AbaEIAY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 20:24:58 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Randy Dunlap <rdunlap@infradead.org>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [patch v2] Documentation/email-clients.txt: add a section about git
References: <536A5A1E.6070004@codeaurora.org> <20140508084412.GA20398@mwanda>
Date: Fri, 09 May 2014 09:24:56 +0900
In-Reply-To: <20140508084412.GA20398@mwanda> (Dan Carpenter's message of "Thu,
	8 May 2014 11:44:12 +0300")
Message-ID: <8738gjol2f.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan,

On Thu, 8 May 2014 11:44:12 +0300, Dan Carpenter wrote:
> These days most people use git to send patches so I have added a section
> about that.
>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> v2: Fixed changelog
>
> diff --git a/Documentation/email-clients.txt b/Documentation/email-clients.txt
> index 4e30eba..9004a5fd 100644
> --- a/Documentation/email-clients.txt
> +++ b/Documentation/email-clients.txt
> @@ -1,6 +1,17 @@
>  Email clients info for Linux
>  ======================================================================
>  
> +Git
> +----------------------------------------------------------------------
> +These days most developers use `git send-email` instead of regular
> +email clients.  On the receiving end, maintainers use `git am` to
> +apply the patches.
> +
> +If you are new to git then send your first patch to yourself.  Save it
> +as raw text including all the headers.  Run `cat raw_email.txt | git am`
> +and then review the changelog with `git log -p`.  When that works then

Also the -p option is not needed for just checking the changelog IMHO.
If one needs to check the patch itself too, I think `git show` is
slightly better since it only shows the single commit applied.

Thanks,
Namhyung
