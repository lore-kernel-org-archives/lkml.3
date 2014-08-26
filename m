Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756759AbaHZAQz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 20:16:55 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:37314 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606AbaHZAQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 20:16:53 -0400
Message-ID: <53FBD1F3.4040003@infradead.org>
Date: Mon, 25 Aug 2014 17:16:51 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
CC: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] new page link in SubmittingPatches
References: <1408989981-31192-1-git-send-email-sudipm.mukherjee@gmail.com>
In-Reply-To: <1408989981-31192-1-git-send-email-sudipm.mukherjee@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/25/14 11:06, Sudip Mukherjee wrote:
> new link for - How to piss off a Linux kernel subsystem  maintainer
> 
> Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>

Hi,

I'll apply this patch, but it would really be nice if Greg would make
one contents/index web page for this so that it wouldn't have to be updated
just because there is an addition.

Thanks.

> ---
>  Documentation/SubmittingPatches | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/Documentation/SubmittingPatches b/Documentation/SubmittingPatches
> index 0a523c9..482c749 100644
> --- a/Documentation/SubmittingPatches
> +++ b/Documentation/SubmittingPatches
> @@ -794,6 +794,7 @@ Greg Kroah-Hartman, "How to piss off a kernel subsystem maintainer".
>    <http://www.kroah.com/log/linux/maintainer-03.html>
>    <http://www.kroah.com/log/linux/maintainer-04.html>
>    <http://www.kroah.com/log/linux/maintainer-05.html>
> +  <http://www.kroah.com/log/linux/maintainer-06.html>
>  
>  NO!!!! No more huge patch bombs to linux-kernel@vger.kernel.org people!
>    <https://lkml.org/lkml/2005/7/11/336>
> 


-- 
~Randy
