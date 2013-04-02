Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933738Ab3DBWen (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 18:34:43 -0400
Received: from casper.infradead.org ([85.118.1.10]:55409 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933660Ab3DBWej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 18:34:39 -0400
Message-ID: <515B4EEC.8000908@infradead.org>
Date: Tue, 02 Apr 2013 14:34:36 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Casey Schaufler <casey@schaufler-ca.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-security-module <linux-security-module@vger.kernel.org>
Subject: Re: [PATCH] Smack: include magic.h in smackfs.c
References: <20130402190929.62cea8988921a2599588a566@canb.auug.org.au> <515B12EB.50303@infradead.org> <515B264E.2020603@schaufler-ca.com>
In-Reply-To: <515B264E.2020603@schaufler-ca.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/13 11:41, Casey Schaufler wrote:
> As reported for linux-next: Tree for Apr 2 (smack)
> Add the required include for smackfs.c
> 
> Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>

Reported-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Randy Dunlap <rdunlap@infradead.org>

Thanks.


> ---
>  security/smack/smackfs.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
> index 2479a41..53a08b8 100644
> --- a/security/smack/smackfs.c
> +++ b/security/smack/smackfs.c
> @@ -26,6 +26,7 @@
>  #include <linux/seq_file.h>
>  #include <linux/ctype.h>
>  #include <linux/audit.h>
> +#include <linux/magic.h>
>  #include "smack.h"
>  
>  /*
> 
> --


-- 
~Randy
