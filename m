Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757749AbaEKAUE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2014 20:20:04 -0400
Received: from merlin.infradead.org ([205.233.59.134]:55200 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756273AbaEKAUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2014 20:20:02 -0400
Message-ID: <536EC22E.2020802@infradead.org>
Date: Sat, 10 May 2014 17:19:58 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, Laura Abbott <lauraa@codeaurora.org>
Subject: Re: [patch v2] Documentation/email-clients.txt: add a section about
 git
References: <20140508084412.GA20398@mwanda>
In-Reply-To: <20140508084412.GA20398@mwanda>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08/2014 01:44 AM, Dan Carpenter wrote:
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

Why is there nothing here about how to use 'git send-email' to send patches?


> +If you are new to git then send your first patch to yourself.  Save it
> +as raw text including all the headers.  Run `cat raw_email.txt | git am`
> +and then review the changelog with `git log -p`.  When that works then
> +send the patch to list.
> +
>  General Preferences
>  ----------------------------------------------------------------------
>  Patches for the Linux kernel are submitted via email, preferably as


-- 
~Randy
