Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895AbaHLQmk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 12:42:40 -0400
Received: from casper.infradead.org ([85.118.1.10]:40181 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753213AbaHLQmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 12:42:39 -0400
Message-ID: <53EA43FA.2040006@infradead.org>
Date: Tue, 12 Aug 2014 09:42:34 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Rahul Bedarkar <rahulbedarkar89@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jiri Kosina <trivial@kernel.org>
Subject: Re: [PATCH] Documentation: kmemleak: correct spelling mistake
References: <1406830819-7661-1-git-send-email-rahulbedarkar89@gmail.com>
In-Reply-To: <1406830819-7661-1-git-send-email-rahulbedarkar89@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31/14 11:20, Rahul Bedarkar wrote:
> Signed-off-by: Rahul Bedarkar <rahulbedarkar89@gmail.com>

Acked-by: Randy Dunlap <rdunlap@infradead.org>

Jiri, please add to trivial.  Thanks.

> ---
>  Documentation/kmemleak.txt | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/kmemleak.txt b/Documentation/kmemleak.txt
> index b772418..f4f033c 100644
> --- a/Documentation/kmemleak.txt
> +++ b/Documentation/kmemleak.txt
> @@ -122,7 +122,7 @@ Then as usual to get your report with:
>  Freeing kmemleak internal objects
>  ---------------------------------
>  
> -To allow access to previosuly found memory leaks after kmemleak has been
> +To allow access to previously found memory leaks after kmemleak has been
>  disabled by the user or due to an fatal error, internal kmemleak objects
>  won't be freed when kmemleak is disabled, and those objects may occupy
>  a large part of physical memory.
> 


-- 
~Randy
