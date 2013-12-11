Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751585Ab3LKPz7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 10:55:59 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:20291 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476Ab3LKPz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 10:55:58 -0500
Message-ID: <52A88AFB.7000204@oracle.com>
Date: Wed, 11 Dec 2013 10:55:39 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>, joern@logfs.org,
        mgorman@suse.de, Michel Lespinasse <walken@google.com>,
        riel@redhat.com, LKML <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: kernel BUG in munlock_vma_pages_range
References: <52A3D0C3.1080504@oracle.com> <52A58E8A.3050401@suse.cz> <52A5F83F.4000207@oracle.com> <alpine.LRH.2.00.1312092215340.1515@twin.jikos.cz>
In-Reply-To: <alpine.LRH.2.00.1312092215340.1515@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2013 04:16 PM, Jiri Kosina wrote:
> On Mon, 9 Dec 2013, Sasha Levin wrote:
>
>> Not really, the fuzzer hit it once and I've been unable to trigger it
>> again.
>
> If you are ever able to trigger it again, I think having crashdump
> available would be very helpful here, to see how exactly does the VMA/THP
> layout look like at the time of crash.
>
> Any chance you run your fuzzing with crashkernel configured for a while?
>

Been trying to, can't get crashkernel to interact nicely with my KVM tools guest.

Will keep trying.


Thanks,
Sasha
