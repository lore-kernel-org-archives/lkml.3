Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752643Ab3HCQ5W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Aug 2013 12:57:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41286 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752457Ab3HCQ5U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Aug 2013 12:57:20 -0400
Date: Sat, 3 Aug 2013 18:51:55 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Zach Levis <zml@linux.vnet.ibm.com>
Cc: akpm@linux-foundation.org, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        dan.carpenter@oracle.com, Zach Levis <zach@zachsthings.com>
Subject: Re: [PATCH v3 3/3] fs/binfmts: Whitespace fixes with
	scripts/cleanfile
Message-ID: <20130803165155.GC32568@redhat.com>
References: <1374766845-13565-1-git-send-email-zml@linux.vnet.ibm.com> <1375485703-4077-4-git-send-email-zml@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375485703-4077-4-git-send-email-zml@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02, Zach Levis wrote:
>
> Obligatory first-patchset whitespace commit

Looks good, perhaps you send it as 1/3 or even separately, so you
won't need to redo it if you need to update 1-2.

> @@ -63,11 +63,11 @@ static int load_em86(struct linux_binprm *bprm)
>  	 */
>  	remove_arg_zero(bprm);
>  	retval = copy_strings_kernel(1, &bprm->filename, bprm);
> -	if (retval < 0) return retval; 
> +	if (retval < 0) return retval;

And perhaps you can also fix the coding style when your patch touches
such a code.

Oleg.

