Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752302Ab3IUGq4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Sep 2013 02:46:56 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:60269 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082Ab3IUGqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Sep 2013 02:46:55 -0400
Message-ID: <523D40A3.4050906@linux.vnet.ibm.com>
Date: Sat, 21 Sep 2013 12:15:55 +0530
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Linux PPC dev <linuxppc-dev@ozlabs.org>, ellerman@au1.ibm.com,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        michael.neuling@au1.ibm.com
Subject: Re: [PATCH V2 0/6] perf: New conditional branch filter
References: <1377836690-32710-1-git-send-email-khandual@linux.vnet.ibm.com> <CABPqkBS2AD873tHnyCHeC7uwsJdP1V6=8WGUTHG+R0z2pphHjQ@mail.gmail.com> <523D3FA2.2070209@linux.vnet.ibm.com>
In-Reply-To: <523D3FA2.2070209@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13092106-2000-0000-0000-00000DCF764B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/21/2013 12:11 PM, Anshuman Khandual wrote:
> On 08/30/2013 05:18 PM, Stephane Eranian wrote:
>> 2013/8/30 Anshuman Khandual <khandual@linux.vnet.ibm.com>
>>>>
>>>>         This patchset is the re-spin of the original branch stack sampling
>>>> patchset which introduced new PERF_SAMPLE_BRANCH_COND filter. This patchset
>>>> also enables SW based branch filtering support for PPC64 platforms which have
>>>> branch stack sampling support. With this new enablement, the branch filter support
>>>> for PPC64 platforms have been extended to include all these combinations discussed
>>>> below with a sample test application program.
>>>>
>>>>
>> I am trying to understand which HW has support for capturing the
>> branches: PPC7 or PPC8.
>> Then it seems you're saying that only PPC8 has the filtering support.
>> On PPC7 you use the
>> SW filter. Did I get this right?
>>
>> I will look at the patch set.
>>
> 
> Hey Stephane,
> 
> Just wondering if you got a chance to go though the patchset ?


s/though/through/

