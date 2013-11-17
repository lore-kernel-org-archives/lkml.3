Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753667Ab3KQA6B (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Nov 2013 19:58:01 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:40875 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753152Ab3KQA5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Nov 2013 19:57:55 -0500
Message-ID: <1384649867.7518.48.camel@fishsauce>
Subject: Re: [tpmdd-devel] [PATCH 3/5 v2] tpm: Create a tpm_class_ops
 structure and use it in the drivers
From: Ashley Lai <adlai@linux.vnet.ibm.com>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: tpmdd-devel@lists.sourceforge.net, Peter Huewe <peterhuewe@gmx.de>,
        linux-kernel@vger.kernel.org
Date: Sat, 16 Nov 2013 18:57:47 -0600
In-Reply-To: <1383536326-28772-4-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1383536326-28772-1-git-send-email-jgunthorpe@obsidianresearch.com>
	 <1383536326-28772-4-git-send-email-jgunthorpe@obsidianresearch.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13111700-7164-0000-0000-00000361DEB6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-11-03 at 20:38 -0700, Jason Gunthorpe wrote:
> This replaces the static initialization of a tpm_vendor_specific
> structure in the drivers with the standard Linux idiom of providing
> a const structure of function pointers.
> 
> Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
> Reviewed-by: Joel Schopp <jschopp@linux.vnet.ibm.com>

Reviewed-by: Ashley Lai <adlai@linux.vnet.ibm.com>
Acked-by: Ashley Lai <adlai@linux.vnet.ibm.com>

Thanks,
--Ashley Lai

