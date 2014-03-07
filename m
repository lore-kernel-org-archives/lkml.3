Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753083AbaCGMZS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 07:25:18 -0500
Received: from mail-yk0-f174.google.com ([209.85.160.174]:62713 "EHLO
	mail-yk0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752914AbaCGMZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 07:25:12 -0500
Date: Fri, 7 Mar 2014 07:25:09 -0500
From: Tejun Heo <tj@kernel.org>
To: Kees Cook <keescook@chromium.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrew Honig <ahonig@google.com>, Michal Marek <mmarek@suse.cz>,
        "x86@kernel.org" <x86@kernel.org>, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>, linux-ia64@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] kallsyms: handle special absolute symbols
Message-ID: <20140307122509.GA30778@htj.dyndns.org>
References: <1394152324-26304-1-git-send-email-keescook@chromium.org>
 <1394152324-26304-3-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394152324-26304-3-git-send-email-keescook@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> diff --git a/scripts/kallsyms.c b/scripts/kallsyms.c
> index 3c6224728960..4dcda98427cb 100644
> --- a/scripts/kallsyms.c
> +++ b/scripts/kallsyms.c
> @@ -34,6 +34,7 @@ struct sym_entry {
>  	unsigned int len;
>  	unsigned int start_pos;
>  	unsigned char *sym;
> +	int force_absolute;

bool?

Thanks.

-- 
tejun
