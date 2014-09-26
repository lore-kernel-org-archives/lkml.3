Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754847AbaIZMnV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 08:43:21 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:55182 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753994AbaIZMnT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 08:43:19 -0400
Message-ID: <54255F61.4060302@linux.vnet.ibm.com>
Date: Fri, 26 Sep 2014 07:43:13 -0500
From: Brian King <brking@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.8.0
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>,
        Christoph Hellwig <hch@lst.de>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiong <wenxiong@linux.vnet.ibm.com>
Subject: Re: linux-next: build failure after merge of the scsi tree
References: <20140926183450.7474b448@canb.auug.org.au> <20140926083632.GA19463@lst.de> <1411725461.2183.2.camel@jarvis>
In-Reply-To: <1411725461.2183.2.camel@jarvis>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14092612-7182-0000-0000-0000008E790D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/26/2014 04:57 AM, James Bottomley wrote:
> On Fri, 2014-09-26 at 10:36 +0200, Christoph Hellwig wrote:
>> On Fri, Sep 26, 2014 at 06:34:50PM +1000, Stephen Rothwell wrote:
>>> Hi James,
>>>
>>> After merging the scsi tree, today's linux-next build (powerpc
>>> ppc64_defconfig) failed like this:
>>>
>>> drivers/scsi/ipr.c: In function 'ipr_handle_log_data':
>>> drivers/scsi/ipr.c:2468:15: error: 'IPR_IOASC_HW_CMD_FAILED' undeclared (first use in this function)
>>>   if (ioasc == IPR_IOASC_HW_CMD_FAILED &&
>>>                ^
>>>
>>> Caused by commit 3185ea63907c ("ipr: don't log error messages when
>>> applications issues illegal requests").  Someone typoed that name in
>>> ipr.h ...
>>>
>>> I have reverted that commit for today.
>>
>> Thanks.  The fix should be here:
>>
>> http://git.infradead.org/users/hch/scsi-queue.git/commitdiff/d247a70a4d67623eb738176ee703a7bb8b6c325c
> 
> OK, Pushed out.
> 
> I'll wait for the next couple of build cycles before pushing (assuming
> merge window opens on Sunday) just in case more things show up.

Hi James,

Anything preventing this patch set from getting picked up? Do you need a resend?

http://marc.info/?l=linux-scsi&m=140657929221696&w=2

Thanks,

Brian

-- 
Brian King
Power Linux I/O
IBM Linux Technology Center


