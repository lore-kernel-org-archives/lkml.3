Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753553AbaIDM1R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 08:27:17 -0400
Received: from service87.mimecast.com ([91.220.42.44]:58529 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752933AbaIDM1P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 08:27:15 -0400
Message-ID: <54085AA1.7020600@arm.com>
Date: Thu, 04 Sep 2014 13:27:13 +0100
From: Sudeep Holla <sudeep.holla@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Sudeep Holla <sudeep.holla@arm.com>, LKML <linux-kernel@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>, "x86@kernel.org" <x86@kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH v4 01/11] cpumask: factor out show_cpumap into separate
 helper function
References: <1409763617-17074-1-git-send-email-sudeep.holla@arm.com> <1409763617-17074-2-git-send-email-sudeep.holla@arm.com> <20140904062006.GC3190@worktop.ger.corp.intel.com> <54082ADD.6040004@arm.com> <20140904092135.GA346@worktop.programming.kicks-ass.net> <54084246.7010705@arm.com> <20140904112551.GC346@worktop.programming.kicks-ass.net>
In-Reply-To: <20140904112551.GC346@worktop.programming.kicks-ass.net>
X-OriginalArrivalTime: 04 Sep 2014 12:27:10.0253 (UTC) FILETIME=[8C7AFDD0:01CFC83B]
X-MC-Unique: 114090413271212501
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 04/09/14 12:25, Peter Zijlstra wrote:
> On Thu, Sep 04, 2014 at 11:43:18AM +0100, Sudeep Holla wrote:
>>> You could make it bitmap_copy_to_buf() I suppose, and then have a
>>> cpumask inline wrapper, to be fully consistent with the rest of the
>>> implementations.
>>>
>>
>> I liked the second approach, how about patch below ?
>> If will munge it into original patch.
>
> Looks good, one more nit if you will permit :-)
>

Ofcourse :)

>> +int bitmap_copy_to_pagebuf(bool list, const unsigned long *maskp, char *buf)
>
> Maybe s/copy/print/ or something? Its not really a 'copy' as such since
> it very much transforms the bitmap.
>

Makes sense, will update accordingly.

Regards,
Sudeep

