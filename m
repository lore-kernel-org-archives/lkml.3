Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752895Ab3AVNVI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 08:21:08 -0500
Received: from multi.imgtec.com ([194.200.65.239]:13053 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750998Ab3AVNVD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 08:21:03 -0500
Message-ID: <50FE923D.5060108@imgtec.com>
Date: Tue, 22 Jan 2013 13:21:01 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
CC: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <arnd@arndb.de>
Subject: Re: [PATCH v2 64/76] ARC: Add self to MAINTAINERS
References: <1358511930-7424-1-git-send-email-vgupta@synopsys.com> <1358511930-7424-65-git-send-email-vgupta@synopsys.com>
In-Reply-To: <1358511930-7424-65-git-send-email-vgupta@synopsys.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01181__2013_01_22_13_21_02
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18/01/13 12:25, Vineet Gupta wrote:
> Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
> ---
>  MAINTAINERS |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 3105c48..05cdc99 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -7418,6 +7418,12 @@ F:	lib/swiotlb.c
>  F:	arch/*/kernel/pci-swiotlb.c
>  F:	include/linux/swiotlb.h
>  
> +SYNOPSYS ARC ARCHITECTURE
> +M:	Vineet Gupta <vgupta@synopsys.com>
> +L:	linux-snps-arc@vger.kernel.org

Is this set up? I don't see it at
http://vger.kernel.org/vger-lists.html

Incidentally, anybody know who to ask about setting up a new list?

Cheers
James

> +S:	Supported
> +F:	arch/arc/
> +
>  SYSV FILESYSTEM
>  M:	Christoph Hellwig <hch@infradead.org>
>  S:	Maintained
> 

