Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757988AbbA0ED5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 23:03:57 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:54143 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757926AbbA0EDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 23:03:51 -0500
Message-ID: <54C70E07.9040204@fb.com>
Date: Mon, 26 Jan 2015 21:03:19 -0700
From: Jens Axboe <axboe@fb.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Richard Weinberger <richard@nod.at>, Christoph Hellwig <hch@infradead.org>
CC: <dedekind1@gmail.com>, <dwmw2@infradead.org>,
        <computersforpeace@gmail.com>, <linux-mtd@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <tom.leiming@gmail.com>
Subject: Re: [PATCH 2/2 v2] UBI: Block: Add blk-mq support
References: <1420926734-16417-1-git-send-email-richard@nod.at> <1420926734-16417-2-git-send-email-richard@nod.at> <20150113162553.GA24351@infradead.org> <54B5A188.2000001@nod.at> <54B5A213.1090502@fb.com> <54B5A77C.9040405@nod.at> <54B5AA84.9010306@fb.com> <54B5AC10.6070102@nod.at> <54B5B6E4.4020400@fb.com> <54B62B2A.7010109@nod.at> <54C6D408.5050704@nod.at>
In-Reply-To: <54C6D408.5050704@nod.at>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2015-01-27_02:2015-01-27,2015-01-26,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=5.55111512312578e-17 kscore.compositescore=0
 circleOfTrustscore=0 compositescore=0.12498974524102
 urlsuspect_oldscore=0.12498974524102 suspectscore=0
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=2524143
 rbsscore=0.12498974524102 spamscore=0
 recipient_to_sender_domain_totalscore=4 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1501270044
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/26/2015 04:55 PM, Richard Weinberger wrote:
> Am 14.01.2015 um 09:39 schrieb Richard Weinberger:
>> Am 14.01.2015 um 01:23 schrieb Jens Axboe:
>>> Which is as I suspected, you'll do each segment to the length specified,
>>> hence you don't need to track the returned count from blk_rq_map_sg().
>>
>> Thanks a lot for the kind explanation, Jens!
>> I'll add a comment the usage of blk_rq_map_sg() to avoid further confusion.
>> Am I allowed to add your Reviewed-by too?
>
> Ping?
> I'd like to add a Reviewed-by to this patch.

Yup sorry, looks OK to go in from my point of view. You can add my 
reviewed-by.


-- 
Jens Axboe

