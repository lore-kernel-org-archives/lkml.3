Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755216AbaA1P2y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 10:28:54 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:46857 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754706AbaA1P2w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 10:28:52 -0500
Message-ID: <52E7CCAD.5070008@linux.vnet.ibm.com>
Date: Tue, 28 Jan 2014 09:28:45 -0600
From: Brian King <brking@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Alexander Gordeev <agordeev@redhat.com>
CC: Brian King <brking@us.ibm.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, kvm@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wendy Xiong <wenxiong@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 4/9] ipr: Use pci_enable_msi_range() and pci_enable_msix_range()
References: <cover.1389904166.git.agordeev@redhat.com> <eb0b62be65c050533f2565fcf3f1d673770dfd67.1389904166.git.agordeev@redhat.com> <20140128095441.GA6951@dhcp-26-207.brq.redhat.com>
In-Reply-To: <20140128095441.GA6951@dhcp-26-207.brq.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14012815-0320-0000-0000-0000024F3D98
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/28/2014 03:54 AM, Alexander Gordeev wrote:
> On Fri, Jan 17, 2014 at 05:02:18PM +0100, Alexander Gordeev wrote:
>> As result deprecation of MSI-X/MSI enablement functions
>> pci_enable_msix() and pci_enable_msi_block() all drivers
>> using these two interfaces need to be updated to use the
>> new pci_enable_msi_range() and pci_enable_msix_range()
>> interfaces.
>>
>> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> 
> Brian, James,
> 
> Could you please review patches 3 and 4?

These look like they will conflict with a recent patch to
the ipr driver:

http://www.spinics.net/lists/linux-scsi/msg71644.html

Do you want me to rediff your patches on top of this one,
or do you want to keep the entire MSI series together
and do the rediff? Otherwise the patches seem fine.

Thanks,

Brian


-- 
Brian King
Power Linux I/O
IBM Linux Technology Center


