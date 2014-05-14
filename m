Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753070AbaENVMy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 17:12:54 -0400
Received: from merlin.infradead.org ([205.233.59.134]:33942 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260AbaENVMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 17:12:52 -0400
Message-ID: <5373DC51.2080207@infradead.org>
Date: Wed, 14 May 2014 14:12:49 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: Re: [patch v3] Documentation/email-clients.txt: add a section about
 git
References: <20140513133200.GA21702@mwanda>
In-Reply-To: <20140513133200.GA21702@mwanda>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/2014 06:32 AM, Dan Carpenter wrote:
> These days most people use git to send patches so I have added a section
> about that.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> v2: fix typo in commit message
> v3: update git am and log commands.  Mention the man pages.
> 
> diff --git a/Documentation/email-clients.txt b/Documentation/email-clients.txt
> index 4e30eba..9293477 100644
> --- a/Documentation/email-clients.txt
> +++ b/Documentation/email-clients.txt
> @@ -1,6 +1,17 @@
>  Email clients info for Linux
>  ======================================================================
>  
> +Git
> +----------------------------------------------------------------------
> +These days most developers use `git send-email` instead of regular
> +email clients.  The man page for this is quite good.  On the receiving
> +end, maintainers use `git am` to apply the patches.
> +
> +If you are new to git then send your first patch to yourself.  Save it
> +as raw text including all the headers.  Run `git am raw_email.txt` and
> +then review the changelog with `git log`.  When that works then send
> +the patch to list.

how about:
             to the appropriate mailing list(s).
or
             to the mailing list(s).
?


I'm not real crazy about this coming before Everything Else in this
text file, but that's what you intended, right?

> +
>  General Preferences
>  ----------------------------------------------------------------------
>  Patches for the Linux kernel are submitted via email, preferably as
> 


-- 
~Randy
