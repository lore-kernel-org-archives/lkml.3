Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754932Ab3JLBUB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 21:20:01 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53546 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753464Ab3JLBUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 21:20:00 -0400
Message-ID: <5258A3A5.8080700@infradead.org>
Date: Fri, 11 Oct 2013 18:19:33 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: Re: [PATCH] mm: trivial: fix typos
References: <1381163029-8808-1-git-send-email-sjenning@linux.vnet.ibm.com>
In-Reply-To: <1381163029-8808-1-git-send-email-sjenning@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-7
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/13 09:23, Seth Jennings wrote:
> Fix comment typos in swapfile.c
> 
> Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
> ---
>  mm/swapfile.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 3963fc2..7968c1b 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -1179,7 +1179,7 @@ static int unuse_pte_range(struct vm_area_struct *vma, pmd_t *pmd,
>  	 * some architectures (e.g. x86_32 with PAE) we might catch a glimpse
>  	 * of unmatched parts which look like swp_pte, so unuse_pte must
>  	 * recheck under pte lock.  Scanning without pte lock lets it be
> -	 * preemptible whenever CONFIG_PREEMPT but not CONFIG_HIGHPTE.
> +	 * preemptable whenever CONFIG_PREEMPT but not CONFIG_HIGHPTE.

Do you have a dictionary source that backs this one up?

The kernel source uses either spelling.

dict.org doesn't find either spelling.
m-w.com doesn't find either spelling.
However, dictionary.com finds preemptible but not preemptable.


>  	 */
>  	pte = pte_offset_map(pmd, addr);
>  	do {



-- 
~Randy
