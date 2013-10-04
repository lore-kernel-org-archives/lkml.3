Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755246Ab3JDP6J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 11:58:09 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:47456 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755049Ab3JDP6I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 11:58:08 -0400
Message-ID: <1380902278.23565.0.camel@fishsauce>
Subject: Re: [tpmdd-devel] [PATCH 04/13] tpm: Store devname in the tpm_chip
From: Ashley Lai <adlai@linux.vnet.ibm.com>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: tpmdd-devel@lists.sourceforge.net,
        Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, Rajiv Andrade <mail@srajiv.net>,
        Sirrix AG <tpmdd@sirrix.com>
Date: Fri, 04 Oct 2013 10:57:58 -0500
In-Reply-To: <1379960083-8942-5-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1379960083-8942-1-git-send-email-jgunthorpe@obsidianresearch.com>
	 <1379960083-8942-5-git-send-email-jgunthorpe@obsidianresearch.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13100415-0320-0000-0000-0000013E5E1F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-09-23 at 12:14 -0600, Jason Gunthorpe wrote:
> Just put the memory directly in the chip structure, rather than
> in a 2nd dedicated kmalloc.
> 
> Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>

Acked-by: Ashley Lai <adlai@linux.vnet.ibm.com>

Thanks,
--Ashley Lai


