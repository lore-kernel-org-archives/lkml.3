Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754478AbaDYUiz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 16:38:55 -0400
Received: from merlin.infradead.org ([205.233.59.134]:42419 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753730AbaDYUix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 16:38:53 -0400
Message-ID: <535AC7D2.7030603@infradead.org>
Date: Fri, 25 Apr 2014 13:38:42 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Masanari Iida <standby24x7@gmail.com>, wim@iguana.be,
        linux-watchdog@vger.kernel.org, thomas.mingarelli@hp.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] doc: watchdog: Add an usage note on hpwdt with hp-asrd
References: <1398423149-5028-1-git-send-email-standby24x7@gmail.com>
In-Reply-To: <1398423149-5028-1-git-send-email-standby24x7@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25/14 03:52, Masanari Iida wrote:
> An agent software called hp-asrd from Hewlett Packard
> updates same iLO watchdog timer as hpwdt does update.
> So they can not be uses simultaneously.
> Add this usage note in hpwdt.txt.
> 
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>
> ---
>  Documentation/watchdog/hpwdt.txt | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/watchdog/hpwdt.txt b/Documentation/watchdog/hpwdt.txt
> index 9488078..719c38d 100644
> --- a/Documentation/watchdog/hpwdt.txt
> +++ b/Documentation/watchdog/hpwdt.txt
> @@ -89,7 +89,8 @@ Last reviewed: 06/02/2009
>  
>  	Hypertransport/CSI Error       31h
>  
> -
> +hpwdt can not work as expected if hp-asrd is running simultaneously.

         cannot                                                       ,

> +Because both hpwdt and hp-asrd update same iLO watchdog timer.

   because                        update the same

>  
>   -- Tom Mingarelli
>      (thomas.mingarelli@hp.com)
> 


-- 
~Randy
