Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752009Ab3COFEI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 01:04:08 -0400
Received: from ozlabs.org ([203.10.76.45]:56553 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751026Ab3COFEF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 01:04:05 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: James Hogan <james.hogan@imgtec.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, Stephen Rothwell <sfr@canb.auug.org.au>,
        Al Viro <viro@zeniv.linux.org.uk>, Michal Marek <mmarek@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>, Jean Delvare <khali@linux-fr.org>,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mike Frysinger <vapier@gentoo.org>,
        uclinux-dist-devel@blackfin.uclinux.org, linux-next@vger.kernel.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-mtd@lists.infradead.org
Subject: Re: [RFC -next] linux/linkage.h: fix symbol prefix handling
In-Reply-To: <5141AB3A.2060705@imgtec.com>
References: <1362656642-2693-1-git-send-email-james.hogan@imgtec.com> <87sj46wyf2.fsf@rustcorp.com.au> <5139AC39.90805@imgtec.com> <874ngiwije.fsf@rustcorp.com.au> <20130311230731.0c610d86569d09f6e23b8e61@canb.auug.org.au> <87ppz5usts.fsf@rustcorp.com.au> <20130312233300.9d86d47bb5369923ad520a21@canb.auug.org.au> <87ehfkuq27.fsf@rustcorp.com.au> <20130313063157.GB19681@merkur.ravnborg.org> <87zjy6tytz.fsf@rustcorp.com.au> <5141AB3A.2060705@imgtec.com>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Fri, 15 Mar 2013 15:07:31 +1030
Message-ID: <87obelth10.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Hogan <james.hogan@imgtec.com> writes:
> On 14/03/13 04:00, Rusty Russell wrote:
>> From: Rusty Russell <rusty@rustcorp.com.au>
>> Subject: CONFIG_SYMBOL_PREFIX: cleanup.
...
> Reviewed-by: James Hogan <james.hogan@imgtec.com>
> Tested-by: James Hogan <james.hogan@imgtec.com> (metag)

Thanks.

> The only other special case of symbol prefixing I'm aware of is in
> scripts/genksyms/genksyms.c. It makes the decision at runtime based
> on the --arch=$ARCH argument, and is the only use of the arch argument:
>
>> 	if ((strcmp(arch, "h8300") == 0) || (strcmp(arch, "blackfin") == 0) ||
>> 	    (strcmp(arch, "metag") == 0))
>> 		mod_prefix = "_";
>
> Does the patch below look reasonable in addition to your patch?
> (Note: I'm not sure if genksyms is only used internally or whether
> it's API should be kept stable?).
>
> Thanks
> James
>
> Subject: [PATCH] genksyms: pass symbol-prefix instead of arch

Agreed, I've applied this.

Thanks,
Rusty.
