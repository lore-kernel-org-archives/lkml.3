Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752779AbbA1ULt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:11:49 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:42317 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751307AbbA1ULA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:11:00 -0500
Message-ID: <54C925ED.6000302@fb.com>
Date: Wed, 28 Jan 2015 11:09:49 -0700
From: Jens Axboe <axboe@fb.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Brian Norris <computersforpeace@gmail.com>, Arnd Bergmann <arnd@arndb.de>
CC: <linux-mtd@lists.infradead.org>, David Woodhouse <dwmw2@infradead.org>,
        Christoph Hellwig <hch@lst.de>, Tejun Heo <tj@kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] mtd: export new mtd_mmap_capabilities
References: <1900951.4yX9yJNQM5@wuerfel> <20150128180505.GW9759@ld-irv-0074>
In-Reply-To: <20150128180505.GW9759@ld-irv-0074>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2015-01-28_02:2015-01-28,2015-01-28,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 kscore.is_bulkscore=0
 kscore.compositescore=0 circleOfTrustscore=0
 compositescore=0.12498974524102 urlsuspect_oldscore=0.12498974524102
 suspectscore=0 recipient_domain_to_sender_totalscore=0 phishscore=0
 bulkscore=0 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=2524143
 rbsscore=0.12498974524102 spamscore=0
 recipient_to_sender_domain_totalscore=76 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1501280182
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/28/2015 11:05 AM, Brian Norris wrote:
> On Wed, Jan 28, 2015 at 04:19:31PM +0100, Arnd Bergmann wrote:
>> The recently added mtd_mmap_capabilities can be used from loadable
>> modules, in particular romfs, but is not exported, so we get
>>
>> ERROR: "mtd_mmap_capabilities" [fs/romfs/romfs.ko] undefined!
>>
>> This adds the missing export.
>>
>> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>> Fixes: b4caecd48005f ("fs: introduce f_op->mmap_capabilities for nommu mmap support")
>
> Acked-by: Brian Norris <computersforpeace@gmail.com>
>
> This should go through the block tree in which the target commit is
> queued.

Applied to for-3.20/bdi, thanks Arnd.

-- 
Jens Axboe

