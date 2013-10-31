Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568Ab3JaV0W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 17:26:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33704 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751804Ab3JaV0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 17:26:20 -0400
Date: Thu, 31 Oct 2013 14:26:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nicolin Chen <b42378@freescale.com>
Cc: <joe@perches.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][RESEND] lib/genalloc: add a helper function for DMA
 buffer allocation
Message-Id: <20131031142619.d7aed35fe536f5a177012d27@linux-foundation.org>
In-Reply-To: <1383210967-25804-1-git-send-email-b42378@freescale.com>
References: <1383210967-25804-1-git-send-email-b42378@freescale.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Oct 2013 17:16:07 +0800 Nicolin Chen <b42378@freescale.com> wrote:

> When using pool space for DMA buffer, there might be duplicated calling
> of gen_pool_alloc() and gen_pool_virt_to_phys() in each implementation.
> 
> Thus it's better to add a simple helper function, a compatible one to
> the common dma_alloc_coherent(), to save some code.
> 

Well OK, but this new function doesn't have any callers.  So it
increases kernel size and is untestable.

Do you have any conversion patches which we can merge to address these
problems?

