Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922Ab3J3SWs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 14:22:48 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:39435 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865Ab3J3SWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 14:22:46 -0400
Date: Wed, 30 Oct 2013 19:22:41 +0100
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: New kconfig maintainer
Message-ID: <20131030182241.GB3438@free.fr>
References: <1383131264-19233-1-git-send-email-mmarek@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1383131264-19233-1-git-send-email-mmarek@suse.cz>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal, All,

On 2013-10-30 12:07 +0100, Michal Marek spake thusly:
> Yann has been the de facto maintainer of kconfig for some time. Update
> the KCONFIG entry with his emails address and git tree.
> 
> Cc: "Yann E. MORIN" <yann.morin.1998@free.fr>
> Signed-off-by: Michal Marek <mmarek@suse.cz>

Acked-by: "Yann E. MORIN" <yann.morin.1998@free.fr>

Thank you for the trust you've put in me with this patch! :-)

Shall I take this in my tree, or will you add it to yours?

Regards,
Yann E. MORIN.

> ---
>  MAINTAINERS |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index e61c2e8..d083982 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -4723,9 +4723,10 @@ F:	Documentation/hwmon/k8temp
>  F:	drivers/hwmon/k8temp.c
>  
>  KCONFIG
> -M:	Michal Marek <mmarek@suse.cz>
> +M:	"Yann E. MORIN" <yann.morin.1998@free.fr>
>  L:	linux-kbuild@vger.kernel.org
> -S:	Odd Fixes
> +T:	git://gitorious.org/linux-kconfig/linux-kconfig
> +S:	Maintained
>  F:	Documentation/kbuild/kconfig-language.txt
>  F:	scripts/kconfig/
>  
> -- 
> 1.7.3.1
> 

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +33 662 376 056 | Software  Designer | \ / CAMPAIGN     |  ___               |
| +33 223 225 172 `------------.-------:  X  AGAINST      |  \e/  There is no  |
| http://ymorin.is-a-geek.org/ | _/*\_ | / \ HTML MAIL    |   v   conspiracy.  |
'------------------------------^-------^------------------^--------------------'
