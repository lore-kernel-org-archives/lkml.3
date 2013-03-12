Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755097Ab3CLHZ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 03:25:29 -0400
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:44135 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754061Ab3CLHZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 03:25:28 -0400
Date: Tue, 12 Mar 2013 08:25:23 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Ursula Braun <ursula.braun@de.ibm.com>,
        Frank Blaschka <blaschka@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux390@de.ibm.com,
        linux-s390@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 11/18] driver: s390: net: remove cast for kzalloc return
 value
Message-ID: <20130312072523.GD4148@osiris>
References: <513EB23D.7020303@cn.fujitsu.com>
 <513EBBA0.60804@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <513EBBA0.60804@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13031207-4966-0000-0000-0000051FA30B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 12, 2013 at 01:22:40PM +0800, Zhang Yanfei wrote:
> remove cast for kzalloc return value.
> 
> Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
>  drivers/s390/net/qeth_core_main.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
> index 0d8cdff..754a54f 100644
> --- a/drivers/s390/net/qeth_core_main.c
> +++ b/drivers/s390/net/qeth_core_main.c
> @@ -316,7 +316,7 @@ static inline int qeth_alloc_cq(struct qeth_card *card)
>  
>  		card->qdio.no_in_queues = 2;
>  
> -		card->qdio.out_bufstates = (struct qdio_outbuf_state *)
> +		card->qdio.out_bufstates =

Applied, thanks.

