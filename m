Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755426Ab3JDQ2V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 12:28:21 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:37844 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754634Ab3JDQ2T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 12:28:19 -0400
Date: Fri, 4 Oct 2013 10:28:08 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Peter H?we <PeterHuewe@gmx.de>
Cc: tpmdd-devel@lists.sourceforge.net, Ashley Lai <ashley@ashleylai.com>,
        Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, Rajiv Andrade <mail@srajiv.net>,
        Sirrix AG <tpmdd@sirrix.com>
Subject: Re: TPM.ko module rename (was tpm: Pull everything related to
 /dev/tpmX into tpm-dev.c)
Message-ID: <20131004162808.GA10315@obsidianresearch.com>
References: <1379960083-8942-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <201310020114.18624.PeterHuewe@gmx.de>
 <20131003050504.GA2247@obsidianresearch.com>
 <201310041750.01145.PeterHuewe@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201310041750.01145.PeterHuewe@gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 04, 2013 at 05:50:01PM +0200, Peter H?we wrote:

> I'm not 100% sure what's the usual procedure for module renames, especially 
> since this is visible in userspace.
> 
> For users the easiest way would be to rename tpm.c to tpm-core.c and
> leave the module name as it is.  In git that's just a simple rename
> operation.

I agree, keeping the old name seems much safer.

I'm thinking of following the pattern seen in RTC. Rename tpm.c to
tpm-interface.c and eventually migrate all the driver model support
items into tpm-class.c.

Does that seem good? I'll respin the patches and test modular rebuilds.

Jason
