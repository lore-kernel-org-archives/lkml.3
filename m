Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753793Ab3JDQpt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 12:45:49 -0400
Received: from mail-qe0-f54.google.com ([209.85.128.54]:57714 "EHLO
	mail-qe0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988Ab3JDQps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 12:45:48 -0400
Date: Fri, 4 Oct 2013 11:45:43 -0500 (CDT)
From: Ashley Lai <ashley@ashleylai.com>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
cc: Peter H?we <PeterHuewe@gmx.de>, tpmdd-devel@lists.sourceforge.net,
        Ashley Lai <ashley@ashleylai.com>,
        Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, Rajiv Andrade <mail@srajiv.net>,
        Sirrix AG <tpmdd@sirrix.com>
Subject: Re: TPM.ko module rename (was tpm: Pull everything related to
 /dev/tpmX into tpm-dev.c)
In-Reply-To: <20131004162808.GA10315@obsidianresearch.com>
Message-ID: <alpine.DEB.2.02.1310041143060.32687@fishsauce>
References: <1379960083-8942-1-git-send-email-jgunthorpe@obsidianresearch.com> <201310020114.18624.PeterHuewe@gmx.de> <20131003050504.GA2247@obsidianresearch.com> <201310041750.01145.PeterHuewe@gmx.de> <20131004162808.GA10315@obsidianresearch.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 4 Oct 2013, Jason Gunthorpe wrote:

> On Fri, Oct 04, 2013 at 05:50:01PM +0200, Peter H?we wrote:
>
>> I'm not 100% sure what's the usual procedure for module renames, especially
>> since this is visible in userspace.
>>
>> For users the easiest way would be to rename tpm.c to tpm-core.c and
>> leave the module name as it is.  In git that's just a simple rename
>> operation.
>
> I agree, keeping the old name seems much safer.
>
> I'm thinking of following the pattern seen in RTC. Rename tpm.c to
> tpm-interface.c and eventually migrate all the driver model support
> items into tpm-class.c.
>
> Does that seem good? I'll respin the patches and test modular rebuilds.
>
> Jason
>

Me too, I vote to keep the same module name.  Please let me know 
when you are done with this patch, I would like to test it out.

Thanks,
--Ashley Lai
