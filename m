Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161608Ab3FUQoX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 12:44:23 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:41230 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161585Ab3FUQoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 12:44:08 -0400
Message-ID: <51C482CB.9040700@linux.vnet.ibm.com>
Date: Fri, 21 Jun 2013 22:13:55 +0530
From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, "Luck, Tony" <tony.luck@intel.com>
CC: "ananth@in.ibm.com" <ananth@in.ibm.com>,
        "masbock@linux.vnet.ibm.com" <masbock@linux.vnet.ibm.com>,
        "lcm@linux.vnet.ibm.com" <lcm@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>, Robert Richter <rric@kernel.org>
Subject: Re: [PATCH v2 2/2] mce: acpi/apei: Add a boot option to disable ff
 mode for corrected errors
References: <20130619180441.GK28300@pd.tnic> <3908561D78D1C84285E8C5FCA982C28F2DA88106@ORSMSX106.amr.corp.intel.com> <20130619183640.GL28300@pd.tnic> <3908561D78D1C84285E8C5FCA982C28F2DA881C2@ORSMSX106.amr.corp.intel.com> <20130619201438.GM28300@pd.tnic> <3908561D78D1C84285E8C5FCA982C28F2DA8838B@ORSMSX106.amr.corp.intel.com> <20130619210706.GP28300@pd.tnic> <3908561D78D1C84285E8C5FCA982C28F2DA884F0@ORSMSX106.amr.corp.intel.com> <51C37251.4000008@linux.vnet.ibm.com> <3908561D78D1C84285E8C5FCA982C28F2DA8993C@ORSMSX106.amr.corp.intel.com> <20130621072725.GB22006@pd.tnic>
In-Reply-To: <20130621072725.GB22006@pd.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13062116-7014-0000-0000-000003364916
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/21/2013 12:57 PM, Borislav Petkov wrote:
> On Thu, Jun 20, 2013 at 10:11:27PM +0000, Luck, Tony wrote:
>>> - Two, the Generic Error Data Entry (aka UEFI Section Descriptor) has a
>>> flag which indicates 'Error Threshold Exceeded'. From the UEFI spec, it
>>> looks like we could consider this as an indication to offline the page;
>>> though I am not sure if/how this relates to the threshold value above.
>>
>> This one sounds to make sense ... the flag description sounds exactly what
>> we want - I won't feel embarrassed explaining to people why Linux takes
>> action when it sees a record like this.
>
> Yep, and firmware can set that flag when it wants to, so decision when
> to offline a page is left to the platform.
>

Ok, I will work towards a patch which does this.

Thanks,
Naveen

