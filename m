Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874AbaJMOlk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 10:41:40 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:41379 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752656AbaJMOlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 10:41:39 -0400
Message-ID: <543BE49E.2010007@fb.com>
Date: Mon, 13 Oct 2014 08:41:34 -0600
From: Jens Axboe <axboe@fb.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Daniel Cotton <danielcotton.mailinglists@gmail.com>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND] drivers/block/mtip32xx: Fix incorrect warning
References: <543A6C3A.4070408@gmail.com>
In-Reply-To: <543A6C3A.4070408@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.28,0.0.0000
 definitions=2014-10-13_02:2014-10-13,2014-10-13,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=3.39728245535298e-13 kscore.compositescore=0
 circleOfTrustscore=2831.56432933599 compositescore=0.533125042697551
 urlsuspect_oldscore=0.533125042697551 suspectscore=0
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=1996008
 rbsscore=0.533125042697551 spamscore=0
 recipient_to_sender_domain_totalscore=0 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1410130152
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-10-12 05:55, Daniel Cotton wrote:
> Prevent mtip32xx block driver from showing a warning at load time
> ("Error creating debugfs parent") when debugfs is not included in
> the kernel. If debugfs is included, show the error code. Fixes bug
> 55831 in the Bugzilla.

What is the patch against? It doesn't apply to for-3.18/drivers or even 
master.

-- 
Jens Axboe

