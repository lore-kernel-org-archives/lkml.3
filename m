Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933669AbaFQR1i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 13:27:38 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:43537 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933574AbaFQR1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 13:27:36 -0400
Message-ID: <53A07A87.3010908@infradead.org>
Date: Tue, 17 Jun 2014 10:27:35 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Richard Guy Briggs <rgb@redhat.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Documentation: corrected sub-chapter number
References: <1537cb738c6d4998106c5b91626b69f742d2b47d.1402946960.git.rgb@redhat.com>
In-Reply-To: <1537cb738c6d4998106c5b91626b69f742d2b47d.1402946960.git.rgb@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/16/14 12:48, Richard Guy Briggs wrote:
> The index is correct, but there are two sections tagged 3.7.  Fix.
> 
> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>

This seems to already be fixed by commit 49d063cb353265c3af701bab215ac438ca7df36d
on April 7, 2014.

> ---
>  Documentation/filesystems/proc.txt |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
> index f00bee1..68e3a76 100644
> --- a/Documentation/filesystems/proc.txt
> +++ b/Documentation/filesystems/proc.txt
> @@ -1648,7 +1648,7 @@ pids, so one need to either stop or freeze processes being inspected
>  if precise results are needed.
>  
>  
> -3.7	/proc/<pid>/fdinfo/<fd> - Information about opened file
> +3.8	/proc/<pid>/fdinfo/<fd> - Information about opened file
>  ---------------------------------------------------------------
>  This file provides information associated with an opened file. The regular
>  files have at least two fields -- 'pos' and 'flags'. The 'pos' represents
> 


-- 
~Randy
