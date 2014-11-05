Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752845AbaKEAuv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 19:50:51 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:40801 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751792AbaKEAut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 19:50:49 -0500
Message-ID: <5459745D.1000803@fb.com>
Date: Tue, 4 Nov 2014 17:50:37 -0700
From: Jens Axboe <axboe@fb.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Boaz Harrosh <boaz@plexistor.com>, Matthew Wilcox <willy@linux.intel.com>,
        Dmitry Monakhov <dmonakhov@openvz.org>
CC: Ross Zwisler <ross.zwisler@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCHSET 0/5 v2] brd: partition fixes
References: <53FDF7AD.5000709@plexistor.com> <54044759.9080103@gmail.com> <540EEE2C.1090801@plexistor.com> <540F0DDF.3010907@fb.com> <5443F90A.4030606@plexistor.com> <5458FC1F.1070604@plexistor.com>
In-Reply-To: <5458FC1F.1070604@plexistor.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.28,0.0.0000
 definitions=2014-11-05_01:2014-11-04,2014-11-04,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 kscore.is_bulkscore=0
 kscore.compositescore=0 circleOfTrustscore=0
 compositescore=0.925924926977281 urlsuspect_oldscore=0.925924926977281
 suspectscore=0 recipient_domain_to_sender_totalscore=0 phishscore=0
 bulkscore=0 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=64355
 rbsscore=0.925924926977281 spamscore=0
 recipient_to_sender_domain_totalscore=0 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1411050008
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-11-04 09:17, Boaz Harrosh wrote:
> On 10/19/2014 08:46 PM, Boaz Harrosh wrote:
>> On 09/09/2014 05:25 PM, Jens Axboe wrote:
>>> On 09/09/2014 06:10 AM, Boaz Harrosh wrote:
>> <>
>>>> Please tell me what you want to do with these patches. They must go into this Kernel
>>>> cycle before brd is released with wrong user-mode visible nub
>>>>
>> <>
>>> I will drop the 3/5 patch (do that one separately) and queue up and test.
>>>
>>
>> Hi Jens
>>
>> So the Kernel closed with a wrong knob and Even with the new merge window
>> these patches are not merged.
>>
>> Could you at least tell me what you do not like about them so I can fix
>> it?
>>
>> Thanks
>> Boaz
>>
>
> Ping ?

Lets get it applied for 3.19. Some of the patches needed updating, 
either dropped or commit log changed/updated. Can you resend the series?


-- 
Jens Axboe

