Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751574AbaHQSpp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 14:45:45 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:59315 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751404AbaHQSpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 14:45:44 -0400
Message-ID: <53F0F84B.3080806@fb.com>
Date: Sun, 17 Aug 2014 12:45:31 -0600
From: Jens Axboe <axboe@fb.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Dmitry Monakhov <dmonakhov@openvz.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] brd: add ram disk visibility option
References: <1408204530-16726-1-git-send-email-dmonakhov@openvz.org>
In-Reply-To: <1408204530-16726-1-git-send-email-dmonakhov@openvz.org>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.27,0.0.0000
 definitions=2014-08-17_02:2014-08-15,2014-08-17,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 kscore.is_bulkscore=0
 kscore.compositescore=0 circleOfTrustscore=4.9711487605985
 compositescore=0.99797067526462 urlsuspect_oldscore=0.99797067526462
 suspectscore=0 recipient_domain_to_sender_totalscore=0 phishscore=0
 bulkscore=0 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=64355
 rbsscore=0.99797067526462 spamscore=0
 recipient_to_sender_domain_totalscore=0 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1408170243
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-08-16 09:55, Dmitry Monakhov wrote:
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>

You forgot a commit message justifying this change?

-- 
Jens Axboe

