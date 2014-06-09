Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870AbaFIPlF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 11:41:05 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:63755 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752000AbaFIPlC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 11:41:02 -0400
Message-ID: <5395D56C.4000304@fb.com>
Date: Mon, 9 Jun 2014 09:40:28 -0600
From: Jens Axboe <axboe@fb.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Ming Lei <tom.leiming@gmail.com>
CC: =?UTF-8?B?TWF0aWFzIEJqw7hybGluZw==?= <m@bjorling.me>,
        Matthew Wilcox <willy@linux.intel.com>,
        Keith Busch <keith.busch@intel.com>,
        "Sam Bradshaw (sbradshaw)" <sbradshaw@micron.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-nvme <linux-nvme@lists.infradead.org>
Subject: Re: [PATCH v6] NVMe: conversion to blk-mq
References: <1402057225-7312-1-git-send-email-m@bjorling.me>	<1402057225-7312-2-git-send-email-m@bjorling.me>	<CACVXFVOieM2cT4FFJhD9MecfCLBtE3AwjCpOeGGRUcmWnN=B=A@mail.gmail.com>	<5395BFF2.2080402@fb.com>	<CACVXFVPGO9vsOv_uVa0+5AdBduu1RJ0Fmg8XPx1QgJAvnjKj_g@mail.gmail.com>	<5395CE64.6040402@fb.com> <CACVXFVMQ_ehnsj=7+6-WmKLSQAhDRDvOEnE6Ekbwj8sfYuuRAA@mail.gmail.com>
In-Reply-To: <CACVXFVMQ_ehnsj=7+6-WmKLSQAhDRDvOEnE6Ekbwj8sfYuuRAA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-06-09_03:2014-06-09,2014-06-09,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=1.16573417585641e-15 kscore.compositescore=0
 circleOfTrustscore=0 compositescore=0.533125042697551
 urlsuspect_oldscore=0.533125042697551 suspectscore=0
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=1996008
 rbsscore=0.533125042697551 spamscore=0
 recipient_to_sender_domain_totalscore=0 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1406090204
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-06-09 09:15, Ming Lei wrote:
> On Mon, Jun 9, 2014 at 11:10 PM, Jens Axboe <axboe@fb.com> wrote:
>> On 2014-06-09 09:07, Ming Lei wrote:
>>
>> You are right, I didn't get to the bottom of the thread first.
>> Might be better to just have ->start_time set always, regardless of io stats
>> being enabled or not.
>
> Yes, just like what non-mq code did.

I queued up a fix for it.

-- 
Jens Axboe

