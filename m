Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751817Ab3JEBsI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 21:48:08 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:40494 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751307Ab3JEBsH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 21:48:07 -0400
Message-ID: <1380937673.23565.1.camel@fishsauce>
Subject: Re: [tpmdd-devel] [PATCH 05/13] tpm: Use container_of to locate the
 tpm_chip in tpm_open
From: Ashley Lai <adlai@linux.vnet.ibm.com>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: tpmdd-devel@lists.sourceforge.net,
        Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, Rajiv Andrade <mail@srajiv.net>,
        Sirrix AG <tpmdd@sirrix.com>
Date: Fri, 04 Oct 2013 20:47:53 -0500
In-Reply-To: <1379960083-8942-6-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1379960083-8942-1-git-send-email-jgunthorpe@obsidianresearch.com>
	 <1379960083-8942-6-git-send-email-jgunthorpe@obsidianresearch.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13100501-0320-0000-0000-0000013FF3D0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-09-23 at 12:14 -0600, Jason Gunthorpe wrote:
> misc_open sets the file->private_date to the misc_dev when calling
> open. We can use container_of to go from the misc_dev back to the
> tpm_chip.
> 
> Future clean ups will move tpm_open into a new file and this change
> means we do not have to export the tpm_chip list.
> 
> Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>

Acked-by: Ashley Lai <adlai@linux.vnet.ibm.com>

Thanks,
--Ashley Lai

