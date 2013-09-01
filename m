Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756825Ab3IABDb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 21:03:31 -0400
Received: from merlin.infradead.org ([205.233.59.134]:34287 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753024Ab3IABDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 21:03:30 -0400
Message-ID: <52229245.5070004@infradead.org>
Date: Sat, 31 Aug 2013 18:03:01 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Masanari Iida <standby24x7@gmail.com>
CC: linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: Re: [PATCH] [trivial]treewide: Fix typo in Kconfig
References: <1377420828-32716-1-git-send-email-standby24x7@gmail.com>
In-Reply-To: <1377420828-32716-1-git-send-email-standby24x7@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/25/13 01:53, Masanari Iida wrote:
> Correct spelling typo in various Kconfig files.
> 
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>

Acked-by: Randy Dunlap <rdunlap@infradead.org>


> diff --git a/init/Kconfig b/init/Kconfig
> index 3ecd8a1..43d7554 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -536,7 +536,7 @@ config CONTEXT_TRACKING_FORCE
>  	  dynticks working.
>  
>  	  This option stands for testing when an arch implements the
> -	  context tracking backend but doesn't yet fullfill all the
> +	  context tracking backend but doesn't yet fulfill all the

I usually spell it "fulfil" but either way is OK.

>  	  requirements to make the full dynticks feature working.
>  	  Without the full dynticks, there is no way to test the support
>  	  for context tracking and the subsystems that rely on it: RCU


Thanks.

-- 
~Randy
