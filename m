Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261AbaBXRVr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 12:21:47 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:50322 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753227AbaBXRVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 12:21:45 -0500
Message-ID: <530B7F75.1050600@fb.com>
Date: Mon, 24 Feb 2014 09:20:53 -0800
From: Jens Axboe <axboe@fb.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Jan Kara <jack@suse.cz>, Don Zickus <dzickus@redhat.com>,
        Michal Hocko <mhocko@suse.cz>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: [PATCH 00/11] smp: Single IPI cleanups v2
References: <1393256402-16907-1-git-send-email-fweisbec@gmail.com>
In-Reply-To: <1393256402-16907-1-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2014-02-24_02:2014-02-21,2014-02-24,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 kscore.is_bulkscore=0
 kscore.compositescore=0 circleOfTrustscore=10.2182442654167
 compositescore=0.307752384302029 urlsuspect_oldscore=0.307752384302029
 suspectscore=0 recipient_domain_to_sender_totalscore=0 phishscore=0
 bulkscore=0 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=2524143
 rbsscore=0.307752384302029 spamscore=0
 recipient_to_sender_domain_totalscore=16 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1305240000
 definitions=main-1402240088
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-02-24 07:39, Frederic Weisbecker wrote:
> Hi,
>
> This version includes:
>
> * Rename __smp_call_function_single to smp_call_function_single() as
>    suggested by Christoph.
>
> * Acks and reviewed-by added.
>
> * Rebase against -rc4
>
> Thanks.

I'd be happy to take this in, as it's mostly centered around the blk 
cleanups.

-- 
Jens Axboe

