Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566AbaLABcP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 20:32:15 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:21295 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752064AbaLABcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 20:32:13 -0500
Message-ID: <547BC518.40806@fb.com>
Date: Sun, 30 Nov 2014 18:32:08 -0700
From: Jens Axboe <axboe@fb.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Shaohua Li <shli@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] blk-mq: move the kdump check to blk_mq_alloc_tag_set
References: <8bbd9edbdc0c1e8550af9607d3765a44145be5bd.1417391479.git.shli@kernel.org>
In-Reply-To: <8bbd9edbdc0c1e8550af9607d3765a44145be5bd.1417391479.git.shli@kernel.org>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2014-11-30_03:2014-11-28,2014-11-30,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=1.84241510936545e-13 kscore.compositescore=0
 circleOfTrustscore=502.112 compositescore=0.986137415400633
 urlsuspect_oldscore=0.986137415400633 suspectscore=0
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=62764
 rbsscore=0.986137415400633 spamscore=0
 recipient_to_sender_domain_totalscore=0 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1412010014
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/30/2014 05:00 PM, Shaohua Li wrote:
> We call blk_mq_alloc_tag_set() first then blk_mq_init_queue(). The requests are
> allocated in the former function. So the kdump check should be moved to there
> to really save memory.

Strange, it was even tested, but must have been altered after the fact. 
Patch looks good to me, applied.

-- 
Jens Axboe

