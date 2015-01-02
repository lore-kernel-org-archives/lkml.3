Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752478AbbABPxK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 10:53:10 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:3570 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752099AbbABPxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 10:53:08 -0500
Message-ID: <54A6BEE7.3020601@fb.com>
Date: Fri, 2 Jan 2015 08:53:11 -0700
From: Jens Axboe <axboe@fb.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Ming Lei <ming.lei@canonical.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] block: fix checking return value of blk_mq_init_queue
References: <1420208727-9563-1-git-send-email-ming.lei@canonical.com>
In-Reply-To: <1420208727-9563-1-git-send-email-ming.lei@canonical.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2015-01-02_06:2014-12-31,2015-01-02,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=5.55111512312578e-15 kscore.compositescore=0
 circleOfTrustscore=26.0548541350743 compositescore=0.986137415400633
 urlsuspect_oldscore=0.986137415400633 suspectscore=0
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=62764
 rbsscore=0.986137415400633 spamscore=0
 recipient_to_sender_domain_totalscore=0 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1501020153
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/02/2015 07:25 AM, Ming Lei wrote:
> Check IS_ERR_OR_NULL(return value) instead of just return value.

Thanks Ming, applied.

-- 
Jens Axboe

