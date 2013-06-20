Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753065Ab3FTF0s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 01:26:48 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:42257 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751745Ab3FTF0r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 01:26:47 -0400
Date: Thu, 20 Jun 2013 00:26:44 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: [PATCH] Documentation/cgroups/memory.txt: fix stat file
 documentation
To: Aaro Koskinen <aaro.koskinen@nsn.com>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Aaro Koskinen <aaro.koskinen@nsn.com>, trivial@kernel.org
References: <1371645269-19762-1-git-send-email-aaro.koskinen@nsn.com>
In-Reply-To: <1371645269-19762-1-git-send-email-aaro.koskinen@nsn.com> (from
	aaro.koskinen@nsn.com on Wed Jun 19 07:34:29 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1371706004.2776.132@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/19/2013 07:34:29 AM, Aaro Koskinen wrote:
> Documentation for inactive_anon / active_anon was mixed up. Fix that.
> 
> Signed-off-by: Aaro Koskinen <aaro.koskinen@nsn.com>

Acked-by: Rob Landley <rob@landley.net>

> ---
>  Documentation/cgroups/memory.txt |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/cgroups/memory.txt  
> b/Documentation/cgroups/memory.txt
> index ddf4f93..b63be03 100644
> --- a/Documentation/cgroups/memory.txt
> +++ b/Documentation/cgroups/memory.txt
> @@ -490,10 +490,10 @@ pgpgin		- # of charging events to the  
> memory cgroup. The charging
>  pgpgout		- # of uncharging events to the memory cgroup.  
> The uncharging
>  		event happens each time a page is unaccounted from the  
> cgroup.
>  swap		- # of bytes of swap usage
> -inactive_anon	- # of bytes of anonymous memory and swap cache  
> memory on
> +inactive_anon	- # of bytes of anonymous and swap cache memory  
> on inactive
>  		LRU list.
>  active_anon	- # of bytes of anonymous and swap cache memory on  
> active
> -		inactive LRU list.
> +		LRU list.
>  inactive_file	- # of bytes of file-backed memory on inactive  
> LRU list.
>  active_file	- # of bytes of file-backed memory on active LRU list.
>  unevictable	- # of bytes of memory that cannot be reclaimed  
> (mlocked etc).
> --
> 1.7.10.4
> 
> 

