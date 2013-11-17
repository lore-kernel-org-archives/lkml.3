Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753603Ab3KQBKA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Nov 2013 20:10:00 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:48359 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753215Ab3KQBJu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Nov 2013 20:09:50 -0500
Message-ID: <1384650583.7518.49.camel@fishsauce>
Subject: Re: [tpmdd-devel] [PATCH 4/5 v2] tpm: Use the ops structure instead
 of	a copy in tpm_vendor_specific
From: Ashley Lai <adlai@linux.vnet.ibm.com>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: tpmdd-devel@lists.sourceforge.net, Peter Huewe <peterhuewe@gmx.de>,
        linux-kernel@vger.kernel.org
Date: Sat, 16 Nov 2013 19:09:43 -0600
In-Reply-To: <1383536326-28772-5-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1383536326-28772-1-git-send-email-jgunthorpe@obsidianresearch.com>
	 <1383536326-28772-5-git-send-email-jgunthorpe@obsidianresearch.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13111701-0320-0000-0000-000001BEEF7E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-11-03 at 20:38 -0700, Jason Gunthorpe wrote:
> This builds on the last commit to use the ops structure in the core
> and reduce the size of tpm_vendor_specific.
> 
> Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
> Reviewed-by: Joel Schopp <jschopp@linux.vnet.ibm.com>
> ---

Reviewed-by: Ashley Lai <adlai@linux.vnet.ibm.com>
Acked-by: Ashley Lai <adlai@linux.vnet.ibm.com>

Thanks,
--Ashley Lai

