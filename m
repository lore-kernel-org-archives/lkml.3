Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817Ab3K2VNE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 16:13:04 -0500
Received: from quartz.orcorp.ca ([184.70.90.242]:40656 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753517Ab3K2VM7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 16:12:59 -0500
Date: Fri, 29 Nov 2013 14:12:52 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Michal Nazarewicz <mpn@google.com>
Cc: Peter Huewe <peterhuewe@gmx.de>, Dan Morav <dmorav@nuvoton.com>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] char: tpm: nuvoton: remove unused variable
Message-ID: <20131129211252.GB25451@obsidianresearch.com>
References: <1385744418-9516-1-git-send-email-mpn@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1385744418-9516-1-git-send-email-mpn@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 29, 2013 at 06:00:18PM +0100, Michal Nazarewicz wrote:
> From: Michal Nazarewicz <mina86@mina86.com>
> 
> “wait” wait queue is defined but never used in the function, thus
> it can be removed.
> 
> Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
>  drivers/char/tpm/tpm_i2c_nuvoton.c | 1 -
>  1 file changed, 1 deletion(-)

Acked-By: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>

Thanks,
Jason
