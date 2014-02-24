Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783AbaBXWq1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 17:46:27 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:39968 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752464AbaBXWq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 17:46:26 -0500
Message-ID: <530BCB99.6090907@fb.com>
Date: Mon, 24 Feb 2014 14:45:45 -0800
From: Jens Axboe <axboe@fb.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Jan Kara <jack@suse.cz>, Don Zickus <dzickus@redhat.com>,
        Michal Hocko <mhocko@suse.cz>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: [PATCH 00/11] smp: Single IPI cleanups v2
References: <1393256402-16907-1-git-send-email-fweisbec@gmail.com> <530B7F75.1050600@fb.com> <20140224203743.GF14009@localhost.localdomain>
In-Reply-To: <20140224203743.GF14009@localhost.localdomain>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2014-02-24_03:2014-02-21,2014-02-24,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 suspectscore=0 phishscore=0 adultscore=0 bulkscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=7.0.1-1305240000
 definitions=main-1402240139
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-02-24 12:37, Frederic Weisbecker wrote:
> On Mon, Feb 24, 2014 at 09:20:53AM -0800, Jens Axboe wrote:
>> On 2014-02-24 07:39, Frederic Weisbecker wrote:
>>> Hi,
>>>
>>> This version includes:
>>>
>>> * Rename __smp_call_function_single to smp_call_function_single() as
>>>    suggested by Christoph.
>>>
>>> * Acks and reviewed-by added.
>>>
>>> * Rebase against -rc4
>>>
>>> Thanks.
>>
>> I'd be happy to take this in, as it's mostly centered around the blk
>> cleanups.
>
> I initially planned to push this tree to Ingo because I have some nohz patches
> that will depend on this set.
>
> But there is indeed quite some block changes there. So I should let these go
> through your tree to avoid bad conflicts. If you never rebase your tree I can
> work on top if it.

Yeah, plus most of the original singe call function (at least the part 
where it didn't suck big time) kernel/smp.c functionality in this area 
came in through me/block to begin with as well.

I'll queue it up for 3.15.

-- 
Jens Axboe

