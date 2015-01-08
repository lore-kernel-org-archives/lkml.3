Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756647AbbAHPHs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 10:07:48 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:60243 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753486AbbAHPHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 10:07:47 -0500
Message-ID: <54AE9D3A.1060302@fb.com>
Date: Thu, 8 Jan 2015 08:07:38 -0700
From: Jens Axboe <axboe@fb.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: =?UTF-8?B?SsO8cmcgQmlsbGV0ZXI=?= <j@bitron.ch>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] null_blk: fix blk_mq_init_queue() error handling
References: <1420711456-17257-1-git-send-email-j@bitron.ch>
In-Reply-To: <1420711456-17257-1-git-send-email-j@bitron.ch>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2015-01-08_04:2015-01-07,2015-01-08,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 kscore.is_bulkscore=0
 kscore.compositescore=0 circleOfTrustscore=0
 compositescore=0.925924926977281 urlsuspect_oldscore=0.925924926977281
 suspectscore=0 recipient_domain_to_sender_totalscore=0 phishscore=0
 bulkscore=0 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=62764
 rbsscore=0.925924926977281 spamscore=0
 recipient_to_sender_domain_totalscore=0 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1501080144
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/2015 03:04 AM, Jürg Billeter wrote:
> blk_mq_init_queue() returns ERR_PTR() on failure, not NULL.

This is fixed in for-linus, going upstream this week.


-- 
Jens Axboe

