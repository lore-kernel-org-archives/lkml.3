Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752442AbaBZPCO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 10:02:14 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:51522 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356AbaBZPCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 10:02:13 -0500
Message-ID: <530E01EF.904@linux.vnet.ibm.com>
Date: Wed, 26 Feb 2014 09:02:07 -0600
From: Brian King <brking@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Alexander Gordeev <agordeev@redhat.com>
CC: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wendy Xiong <wenxiong@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 4/9] ipr: Use pci_enable_msi_range() and pci_enable_msix_range()
References: <cover.1389904166.git.agordeev@redhat.com> <eb0b62be65c050533f2565fcf3f1d673770dfd67.1389904166.git.agordeev@redhat.com> <20140128095441.GA6951@dhcp-26-207.brq.redhat.com> <52E7CCAD.5070008@linux.vnet.ibm.com> <20140129132651.GA27764@dhcp-26-207.brq.redhat.com> <20140130140630.GA32349@dhcp-26-207.brq.redhat.com> <20140224081209.GA32200@dhcp-26-207.brq.redhat.com>
In-Reply-To: <20140224081209.GA32200@dhcp-26-207.brq.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14022615-1542-0000-0000-000006A2533F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/24/2014 02:12 AM, Alexander Gordeev wrote:
> On Thu, Jan 30, 2014 at 03:06:30PM +0100, Alexander Gordeev wrote:
>> On Wed, Jan 29, 2014 at 02:26:52PM +0100, Alexander Gordeev wrote:
>>>> Do you want me to rediff your patches on top of this one,
>>>> or do you want to keep the entire MSI series together
>>>> and do the rediff? Otherwise the patches seem fine.
>>>
>>> I would prefer the former.
>>
>> Hi Brian,
>>
>> I am sending the refreshed patches on top of "ipr: Handle early EEH".
> 
> Hi Brian,
> 
> What three the two patches you ACKed are against?
> Should I ask James to take them?

Wendy - can you pull in these two patches from Alexander and rebase on
top of the latest patches you've sent upstream?

Thanks,

Brian

-- 
Brian King
Power Linux I/O
IBM Linux Technology Center


