Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753813AbaFKVdu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 17:33:50 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:48339 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752572AbaFKVds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 17:33:48 -0400
Message-ID: <5398CB38.2000101@fb.com>
Date: Wed, 11 Jun 2014 15:33:44 -0600
From: Jens Axboe <axboe@fb.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Mike Snitzer <snitzer@redhat.com>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] null_blk: fix name and description of 'queue_mode' module
 parameter
References: <1402521230-28330-1-git-send-email-snitzer@redhat.com>
In-Reply-To: <1402521230-28330-1-git-send-email-snitzer@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-06-11_06:2014-06-11,2014-06-11,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=1.85851605771781e-08 kscore.compositescore=0
 circleOfTrustscore=112.429318596174 compositescore=0.998981209195878
 urlsuspect_oldscore=0.998981209195878 suspectscore=0
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=64355
 rbsscore=0.998981209195878 spamscore=0
 recipient_to_sender_domain_totalscore=0 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1406110273
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11/2014 03:13 PM, Mike Snitzer wrote:
> 'use_mq' is not the name of the module parameter, 'queue_mode' is.

Thanks Mike.


