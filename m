Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753662Ab3KQCBb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Nov 2013 21:01:31 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:39950 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753338Ab3KQCBW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Nov 2013 21:01:22 -0500
Message-ID: <1384653674.7518.51.camel@fishsauce>
Subject: Re: [tpmdd-devel] [PATCH 5/5 v2] tpm: Make tpm-dev allocate a
 per-file structure
From: Ashley Lai <adlai@linux.vnet.ibm.com>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: tpmdd-devel@lists.sourceforge.net, Peter Huewe <peterhuewe@gmx.de>,
        linux-kernel@vger.kernel.org
Date: Sat, 16 Nov 2013 20:01:14 -0600
In-Reply-To: <1383536326-28772-6-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1383536326-28772-1-git-send-email-jgunthorpe@obsidianresearch.com>
	 <1383536326-28772-6-git-send-email-jgunthorpe@obsidianresearch.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13111702-7182-0000-0000-000009201DDC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-11-03 at 20:38 -0700, Jason Gunthorpe wrote:
> This consolidates everything that is only used within tpm-dev.c
> into tpm-dev.c and out of the publicly visible struct tpm_chip.
> 
> The per-file allocation lays the ground work for someday fixing the
> strange forced O_EXCL behaviour of the current code.

Reviewed-by: Ashley Lai <adlai@linux.vnet.ibm.com>
Acked-by: Ashley Lai <adlai@linux.vnet.ibm.com>

Thanks,
--Ashley Lai

