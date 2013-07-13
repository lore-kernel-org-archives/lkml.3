Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933307Ab3GMSOM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jul 2013 14:14:12 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:51650 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752Ab3GMSOL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jul 2013 14:14:11 -0400
Date: Sat, 13 Jul 2013 20:14:05 +0200
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        Jean Delvare <jdelvare@suse.de>
Subject: Re: [PATCH 1/3] Documentation/kconfig: more concise and
 straightforward search explanation
Message-ID: <20130713181405.GD3280@free.fr>
References: <1373738905-23396-1-git-send-email-yann.morin.1998@free.fr>
 <1373738905-23396-2-git-send-email-yann.morin.1998@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <1373738905-23396-2-git-send-email-yann.morin.1998@free.fr>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All,

On 2013-07-13 20:08 +0200, Yann E. MORIN spake thusly:
> From: "Yann E. MORIN" <yann.morin.1998@free.fr>
> 
> Re-phrase the explanations on the sorting of search results, in a more
> concise and complete way.
> 
> Drop reference to the user's locale when sorting alphabetically, since
> this is implicit.
> 
> Reported-by: Jean Delvare <jdelvare@suse.de>
> Signed-off-by: "Yann E. MORIN" <yann.morin.1998@free.fr>
> Cc: Jean Delvare <jdelvare@suse.de>
> ---
>  Documentation/kbuild/kconfig.txt | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/Documentation/kbuild/kconfig.txt b/Documentation/kbuild/kconfig.txt
> index e9f9e76..6edf37d 100644
> --- a/Documentation/kbuild/kconfig.txt
> +++ b/Documentation/kbuild/kconfig.txt
> @@ -175,11 +175,9 @@ Searching in menuconfig:
>  		/^hotplug
>  
>  	When searching, symbols are sorted thus:
> -	  - exact match first: an exact match is when the search matches
> -	    the complete symbol name;
> -	  - alphabetical order: when two symbols do not match exactly,
> -	    they are sorted in alphabetical order (in the user's current
> -	    locale).
> +	  - first, exact matches, sorted alphabetically (an exact match                                                                │18:03 -!- - keep a notice in the topic and perhaps as an on-join message).
> +	    is when the search matches the complete symbol name);                                                                      │18:03 -!- -  
> +	  - then, other matches, sorted alphabetically.

Woops, forget this one, it appears I've busted the copy-paste, and
it was too far right on my terminal. I only saw now, as my mailer
wraps long lines.

Sigh... :-(

Sorry,
Yann E. MORIN.

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +33 662 376 056 | Software  Designer | \ / CAMPAIGN     |  ___               |
| +33 223 225 172 `------------.-------:  X  AGAINST      |  \e/  There is no  |
| http://ymorin.is-a-geek.org/ | _/*\_ | / \ HTML MAIL    |   v   conspiracy.  |
'------------------------------^-------^------------------^--------------------'
