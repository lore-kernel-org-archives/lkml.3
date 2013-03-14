Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751220Ab3CNHYD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 03:24:03 -0400
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:57274 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004Ab3CNHYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 03:24:01 -0400
Date: Thu, 14 Mar 2013 08:23:55 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, linux390@de.ibm.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arch: s390: mm: Removed useless label
Message-ID: <20130314072355.GA3480@osiris>
References: <1363203968-17967-1-git-send-email-gheorghiuandru@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363203968-17967-1-git-send-email-gheorghiuandru@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
x-cbid: 13031407-4966-0000-0000-00000527ECAB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 13, 2013 at 09:46:08PM +0200, Alexandru Gheorghiu wrote:
> Rewrote conditional statement and eliminated the out_kthread label.
> 
> Signed-off-by: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
> ---
>  arch/s390/mm/cmm.c |    8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)

Applied, thanks.

