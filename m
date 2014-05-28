Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754310AbaE1OUt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 10:20:49 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:30320 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753310AbaE1OUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 10:20:48 -0400
Message-ID: <5385F0BB.7080406@fb.com>
Date: Wed, 28 May 2014 08:20:43 -0600
From: Jens Axboe <axboe@fb.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: blk-mq: refactor request allocation
References: <1401217190-32453-1-git-send-email-hch@lst.de> <5384FC60.1070103@fb.com> <20140528051919.GA21566@lst.de>
In-Reply-To: <20140528051919.GA21566@lst.de>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.96,1.0.14,0.0.0000
 definitions=2014-05-28_04:2014-05-28,2014-05-28,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=1.08638653628645e-11 kscore.compositescore=0
 circleOfTrustscore=0 compositescore=0.994525499955221
 urlsuspect_oldscore=0.994525499955221 suspectscore=0
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=64355
 rbsscore=0.994525499955221 spamscore=0
 recipient_to_sender_domain_totalscore=0 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1405280186
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-05-27 23:19, Christoph Hellwig wrote:
> On Tue, May 27, 2014 at 02:58:08PM -0600, Jens Axboe wrote:
>> On 05/27/2014 12:59 PM, Christoph Hellwig wrote:
>>> This series streamlines the request allocation path.
>>>
>>
>> Series looks innocuous enough to me, but it's about a 1.5% performance
>> drop here with an actual device. These tests are very stable, anything
>> over ~0.1% is definitely outside of noise. I repeated and rebooted a few
>> times and tested both, it's persistent. No smoking guns in the profile.
>
> Can you do a bisect to narrow it down to one of the patches?

Sure, I'll give it a whirl.

-- 
Jens Axboe

