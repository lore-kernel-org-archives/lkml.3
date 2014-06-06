Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751848AbaFFOUH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 10:20:07 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:49753 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751174AbaFFOUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 10:20:05 -0400
Message-ID: <5391CE0F.9030306@fb.com>
Date: Fri, 6 Jun 2014 08:19:59 -0600
From: Jens Axboe <axboe@fb.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: =?UTF-8?B?TWF0aWFzIEJqw7hybGluZw==?= <m@bjorling.me>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Small correction to blk_rq_set_block_pc
References: <1402055161-25533-1-git-send-email-m@bjorling.me>
In-Reply-To: <1402055161-25533-1-git-send-email-m@bjorling.me>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-06-06_05:2014-06-06,2014-06-06,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=1.74343317560499e-11 kscore.compositescore=0
 circleOfTrustscore=0 compositescore=0.997600857122248
 urlsuspect_oldscore=0.997600857122248 suspectscore=0
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=62764
 rbsscore=0.997600857122248 spamscore=0
 recipient_to_sender_domain_totalscore=0 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1406060191
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-06-06 05:46, Matias Bjørling wrote:
> Hi Jens,
>
> The blk_rq_set_block_pc() overwrites rq->__data_len after its being set in
> blk_rq_map_kern().
>
> It leads to some interesting error messages when booted with SCSI device.

Christoph beat you to it, I folded it in with the previous one.

-- 
Jens Axboe

