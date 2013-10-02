Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847Ab3JBG1p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 02:27:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59686 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752351Ab3JBG1n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 02:27:43 -0400
Date: Wed, 2 Oct 2013 08:27:35 +0200
From: Jean Delvare <jdelvare@suse.de>
To: Martin Walch <walch.martin@web.de>
Cc: Michal Marek <mmarek@suse.cz>, Jiri Kosina <trivial@kernel.org>,
        "Yann E. MORIN" <yann.morin.1998@free.fr>,
        "Arve =?UTF-8?B?SGrDuG5uZXbDpWc=?=" <arve@android.com>,
        Benjamin Poirier <bpoirier@suse.de>, Dirk Gouders <dirk@gouders.net>,
        Wang YanQing <udknight@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>, Alan Cox <alan@linux.intel.com>,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] kconfig: trivial: fix typos
Message-ID: <20131002082735.0fc885ca@endymion.delvare>
In-Reply-To: <1438881.BpsG90UED0@tacticalops>
References: <1438881.BpsG90UED0@tacticalops>
Organization: Suse Linux
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.18; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Martin,

On Wed, 02 Oct 2013 07:24:27 +0200, Martin Walch wrote:
> From: Martin Walch <walch.martin@web.de>
> Date: Wed, 2 Oct 2013 06:56:45 +0200
> Subject: [PATCH 2/4] kconfig: trivial: fix typos
> 
> inser() -> insert(), tell -> tells, peoperty -> property
> 
> Signed-off-by: Martin Walch <walch.martin@web.de>
> ---
>  scripts/kconfig/mconf.c  | 2 +-
>  scripts/kconfig/menu.c   | 2 +-
>  scripts/kconfig/symbol.c | 2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/scripts/kconfig/mconf.c b/scripts/kconfig/mconf.c
> index 2c39631..39abdae 100644
> --- a/scripts/kconfig/mconf.c
> +++ b/scripts/kconfig/mconf.c
> @@ -263,7 +263,7 @@ search_help[] = N_(
>  	"    Press the key in the (#) prefix to jump directly to that\n"
>  	"    location. You will be returned to the current search results\n"
>  	"    after exiting this new menu.\n"
> -	"o The 'Selects:' line tell what symbol will be automatically\n"
> +	"o The 'Selects:' line tells what symbols will be automatically\n"
>  	"  selected if this symbol is selected (y or m)\n"
>  	"o The 'Selected by' line tell what symbol has selected this symbol\n"
>  	"\n"

There are 5 occurrences of this spelling mistake in the paragraph.
Please fix them all. And while you're here, you may find that "what
symbols needs" has a spelling mistake too.

> diff --git a/scripts/kconfig/menu.c b/scripts/kconfig/menu.c
> index c1d5320..b970101 100644
> --- a/scripts/kconfig/menu.c
> +++ b/scripts/kconfig/menu.c
> @@ -597,7 +597,7 @@ static void get_prompt_str(struct gstr *r, struct property *prop,
>  }
>  
>  /*
> - * get peoperty of type P_SYMBOL
> + * get property of type P_SYMBOL
>   */
>  static struct property *get_symbol_prop(struct symbol *sym)
>  {
> diff --git a/scripts/kconfig/symbol.c b/scripts/kconfig/symbol.c
> index c9a6775..7caabdb 100644
> --- a/scripts/kconfig/symbol.c
> +++ b/scripts/kconfig/symbol.c
> @@ -1047,7 +1047,7 @@ sym_re_search_free:
>   * When we check for recursive dependencies we use a stack to save
>   * current state so we can print out relevant info to user.
>   * The entries are located on the call stack so no need to free memory.
> - * Note inser() remove() must always match to properly clear the stack.
> + * Note insert() remove() must always match to properly clear the stack.
>   */
>  static struct dep_stack {
>  	struct dep_stack *prev, *next;

Thanks,
-- 
Jean Delvare
Suse L3
