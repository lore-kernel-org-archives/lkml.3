Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757935Ab3K1Aaq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 19:30:46 -0500
Received: from merlin.infradead.org ([205.233.59.134]:37774 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753959Ab3K1Aap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 19:30:45 -0500
Message-ID: <52968EB2.8010205@infradead.org>
Date: Wed, 27 Nov 2013 16:30:42 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Masanari Iida <standby24x7@gmail.com>, linux-kernel@vger.kernel.org,
        trivial@kernel.org
Subject: Re: [PATCH] [trivial] treewide: Fix typo in Kconfig
References: <1385479189-1862-1-git-send-email-standby24x7@gmail.com>
In-Reply-To: <1385479189-1862-1-git-send-email-standby24x7@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/13 07:19, Masanari Iida wrote:
> Correct spelling typo within various drivers.
> 
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>
> ---


> diff --git a/net/atm/Kconfig b/net/atm/Kconfig
> index 754ea10..1e6de99 100644
> --- a/net/atm/Kconfig
> +++ b/net/atm/Kconfig
> @@ -35,7 +35,7 @@ config ATM_CLIP_NO_ICMP
>  	  cannot be reached because there is no VC to it in the kernel's
>  	  ATMARP table. This may cause problems when ATMARP table entries are
>  	  briefly removed during revalidation. If you say Y here, packets to
> -	  such neighbours are silently discarded instead.
> +	  such neighbors are silently discarded instead.

We accept British or American spellings for that word, so please leave it
as is unless all of the other instances of it are spelled 'neighbor'.

for the rest:
Acked-by: Randy Dunlap <rdunlap@infradead.org>

Thanks.


>  
>  config ATM_LANE
>  	tristate "LAN Emulation (LANE) support"


-- 
~Randy
