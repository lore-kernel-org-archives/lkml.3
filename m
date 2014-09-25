Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987AbaIYRVb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 13:21:31 -0400
Received: from casper.infradead.org ([85.118.1.10]:48876 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752624AbaIYRV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 13:21:29 -0400
Message-ID: <54244F13.2020202@infradead.org>
Date: Thu, 25 Sep 2014 10:21:23 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: oscar@oscr.io
CC: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Kosina <trivial@kernel.org>
Subject: Re: [PATCH 1/1] Changed "&" with "and" in Documentation/applying-patches.txt.
References: <1411652495-100852-1-git-send-email-oscar@oscr.io>
In-Reply-To: <1411652495-100852-1-git-send-email-oscar@oscr.io>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/25/14 06:41, oscar@oscr.io wrote:
> From: Oscar Utbult <oscar@oscr.io>
> 
> http://english.stackexchange.com/questions/3127/when-to-use-instead-of-and
> 
> Signed-off-by: Oscar Utbult <oscar@oscr.io>

Acked-by: Randy Dunlap <rdunlap@infradead.org>

Jiri, for trivial, please.


> ---
>  Documentation/applying-patches.txt | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/applying-patches.txt b/Documentation/applying-patches.txt
> index a083ba3..77df55b 100644
> --- a/Documentation/applying-patches.txt
> +++ b/Documentation/applying-patches.txt
> @@ -94,7 +94,7 @@ Common errors when patching
>  ---
>   When patch applies a patch file it attempts to verify the sanity of the
>  file in different ways.
> -Checking that the file looks like a valid patch file & checking the code
> +Checking that the file looks like a valid patch file and checking the code
>  around the bits being modified matches the context provided in the patch are
>  just two of the basic sanity checks patch does.
>  
> 


-- 
~Randy
