Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754496AbaLVJVH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 04:21:07 -0500
Received: from e06smtp11.uk.ibm.com ([195.75.94.107]:34229 "EHLO
	e06smtp11.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754193AbaLVJVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 04:21:05 -0500
Date: Mon, 22 Dec 2014 10:21:00 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Sebastian Ott <sebott@linux.vnet.ibm.com>,
        Peter Oberparleiter <oberpar@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>, linux390@de.ibm.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] s390: cio: idset.c:  Remove some unused functions
Message-ID: <20141222092100.GA3295@osiris>
References: <1419078469-30933-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419078469-30933-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14122209-0005-0000-0000-0000028C189C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 20, 2014 at 01:27:49PM +0100, Rickard Strandqvist wrote:
> Removes some functions that are not used anywhere:
> idset_clear() idset_sch_get_first()
> 
> This was partially found by using a static code analysis program called cppcheck.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  drivers/s390/cio/idset.c |   20 --------------------
>  drivers/s390/cio/idset.h |    2 --
>  2 files changed, 22 deletions(-)

Applied, thanks!

