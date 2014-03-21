Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760778AbaCUMD4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 08:03:56 -0400
Received: from service87.mimecast.com ([91.220.42.44]:44949 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760703AbaCUMDy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 08:03:54 -0400
Message-ID: <532C2ACD.7070107@arm.com>
Date: Fri, 21 Mar 2014 12:04:29 +0000
From: Sudeep Holla <sudeep.holla@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Anshuman Khandual <khandual@linux.vnet.ibm.com>
CC: Sudeep Holla <sudeep.holla@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH RFC/RFT v3 6/9] powerpc: move cacheinfo sysfs to generic
 cacheinfo infrastructure
References: <1392825976-17633-1-git-send-email-sudeep.holla@arm.com> <1392825976-17633-7-git-send-email-sudeep.holla@arm.com> <531945D1.7010503@linux.vnet.ibm.com> <531963D9.5040701@linux.vnet.ibm.com> <531D9E3A.7040109@arm.com> <532BB5AC.3000904@linux.vnet.ibm.com>
In-Reply-To: <532BB5AC.3000904@linux.vnet.ibm.com>
X-OriginalArrivalTime: 21 Mar 2014 12:04:04.0895 (UTC) FILETIME=[A7C1E2F0:01CF44FD]
X-MC-Unique: 114032112035203501
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Anshuman,

On 21/03/14 03:44, Anshuman Khandual wrote:
> On 03/10/2014 04:42 PM, Sudeep Holla wrote:
>> Hi Anshuman,
>>
>> On 07/03/14 06:14, Anshuman Khandual wrote:
>>> On 03/07/2014 09:36 AM, Anshuman Khandual wrote:
>>>> On 02/19/2014 09:36 PM, Sudeep Holla wrote:
>>>>> From: Sudeep Holla <sudeep.holla@arm.com>
>>>>>
>>>>> This patch removes the redundant sysfs cacheinfo code by making use of
>>>>> the newly introduced generic cacheinfo infrastructure.

[...]

>>>> When it is UNIFIED we return index 0, which is correct. But the index
>>>> for instruction and data cache seems to be swapped which wrong. This
>>>> will fetch invalid properties for any given cache type.
>>>>
>>
>> Ah, that's silly mistake on my side, will fix it.
>>
>>>> I have done some initial review and testing for this patch's impact on
>>>> PowerPC (ppc64 POWER specifically). I am trying to do some code clean-up
>>>> and re-arrangements. Will post out soon. Thanks !
>>
>> Thanks for taking time for testing and reviewing these patches.
> 
> Now that you got some of the problems to work on and resend the patches, I will
> hold on to the clean up patches I had.
> 

I have done most of the changes but still unable to find why the shared_cpu_map
is getting incorrect on PPC. All the other wrong entries are fixed. Any clue on
shared_cpu_map ?

Regards,
Sudeep

