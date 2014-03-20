Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759068AbaCTOeP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 10:34:15 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:26960 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755870AbaCTOeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 10:34:12 -0400
Message-ID: <532AFC5E.8030401@fb.com>
Date: Thu, 20 Mar 2014 08:34:06 -0600
From: Jens Axboe <axboe@fb.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Mike Snitzer <snitzer@redhat.com>, Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: block: free q->flush_rq in blk_init_allocated_queue error paths.
References: <20140318010053.D08A2660CC5@gitolite.kernel.org> <20140319191221.GA10034@redhat.com> <20140319192244.GA17654@redhat.com>
In-Reply-To: <20140319192244.GA17654@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2014-03-20_04:2014-03-20,2014-03-20,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=1.05271236172655e-10 kscore.compositescore=0
 circleOfTrustscore=67.7041584346009 compositescore=0.998981209195878
 urlsuspect_oldscore=0.998981209195878 suspectscore=2
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=64355
 rbsscore=0.998981209195878 spamscore=0
 recipient_to_sender_domain_totalscore=0 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1305240000
 definitions=main-1403200074
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19/2014 01:22 PM, Mike Snitzer wrote:
> On Wed, Mar 19 2014 at  3:12pm -0400,
> Dave Jones <davej@redhat.com> wrote:
>
>> Commit 7982e90c3a ("block: fix q->flush_rq NULL pointer crash on dm-mpath flush")
>> moved an allocation to blk_init_allocated_queue(), but neglected to free
>> that allocation on the error paths that follow.
>>
>> Signed-off-by: Dave Jones <davej@fedoraproject.org>
>
> Ngh.. thanks Dave!
>
> /me hangs his head in shame...
>
> Acked-by: Mike Snitzer <snitzer@redhat.com>
>
> Jens, really sorry about this oversight.  I can take it on the chin and
> pick this up for Linus to take this week from linux-dm.git.  Your call.

No worries, I'll shove it off to Linus today. Then I can punch you on 
the chin next week.

-- 
Jens Axboe

