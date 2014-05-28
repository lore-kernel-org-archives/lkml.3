Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932317AbaE1QTl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 12:19:41 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:21906 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752911AbaE1QTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 12:19:40 -0400
Message-ID: <53860C97.8080708@fb.com>
Date: Wed, 28 May 2014 10:19:35 -0600
From: Jens Axboe <axboe@fb.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] blk-mq: remove alloc_hctx and free_hctx methods
References: <1401293466-24155-1-git-send-email-hch@lst.de>
In-Reply-To: <1401293466-24155-1-git-send-email-hch@lst.de>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.96,1.0.14,0.0.0000
 definitions=2014-05-28_06:2014-05-28,2014-05-28,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=2.09780581794661e-10 kscore.compositescore=0
 circleOfTrustscore=0 compositescore=0.994525499955221
 urlsuspect_oldscore=0.994525499955221 suspectscore=0
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=64355
 rbsscore=0.994525499955221 spamscore=0
 recipient_to_sender_domain_totalscore=0 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1405280212
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-05-28 10:11, Christoph Hellwig wrote:
> There is no need for drivers to control hardware context allocation
> now that we do the context to node mapping in common code.

Excellent, applied.

-- 
Jens Axboe

