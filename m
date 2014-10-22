Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755309AbaJVQiF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 12:38:05 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:40792 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753217AbaJVQhu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 12:37:50 -0400
Date: Wed, 22 Oct 2014 10:37:35 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: Peter Huewe <peterhuewe@gmx.de>, Ashley Lai <ashley@ashleylai.com>,
        Marcel Selhorst <tpmdd@selhorst.net>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org, josh.triplett@intel.com,
        christophe.ricard@gmail.com, jason.gunthorpe@obsidianresearch.com
Subject: Re: [PATCH v1 1/3] tpm: merge duplicate transmit_cmd() functions
Message-ID: <20141022163735.GB12775@obsidianresearch.com>
References: <1413995036-22497-1-git-send-email-jarkko.sakkinen@linux.intel.com>
 <1413995036-22497-2-git-send-email-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413995036-22497-2-git-send-email-jarkko.sakkinen@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2014 at 07:23:54PM +0300, Jarkko Sakkinen wrote:
> Merged transmit_cmd() functions in tpm-interface.c and tpm-sysfs.c.
> Added "tpm_" prefix for consistency sake. Changed cmd parameter as
> opaque. This enables to use separate command structures for TPM1
> and TPM2 commands in future. Loose coupling works fine here.
> 
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

Reviewed-By: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>

Thanks Jarkko!

Jason
