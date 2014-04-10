Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934621AbaDJBib (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 21:38:31 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:29267 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933287AbaDJBia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 21:38:30 -0400
Message-ID: <5345F604.6080207@fb.com>
Date: Wed, 9 Apr 2014 19:38:12 -0600
From: Jens Axboe <axboe@fb.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Jan Kara <jack@suse.cz>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Brian J King <bjking1@us.ibm.com>
Subject: Re: [BUG] kernel BUG at /.../block/cfq-iosched.c:3145!
References: <1397018647.3671.123.camel@pasglop> <53454CBC.9060905@fb.com>	 <1397087273.3671.150.camel@pasglop> <1397088144.3671.155.camel@pasglop>	 <5345F476.2000602@fb.com> <1397093815.3671.156.camel@pasglop>
In-Reply-To: <1397093815.3671.156.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.96,1.0.14,0.0.0000
 definitions=2014-04-09_05:2014-04-09,2014-04-09,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 kscore.is_bulkscore=0
 kscore.compositescore=0 circleOfTrustscore=5.8201264735473
 compositescore=0.307752384302029 urlsuspect_oldscore=0.307752384302029
 suspectscore=0 recipient_domain_to_sender_totalscore=0 phishscore=0
 bulkscore=0 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=2524143
 rbsscore=0.307752384302029 spamscore=0
 recipient_to_sender_domain_totalscore=16 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1404100019
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-04-09 19:36, Benjamin Herrenschmidt wrote:
> On Wed, 2014-04-09 at 19:31 -0600, Jens Axboe wrote:
>> OK, I think we're seeing different symptoms of the same bug. Stay
>> tuned, will have something for you to test shortly, I hope.
>
> Ah thanks. I'll defer the bisection then (it's painful on that machine
> for various reasons....)

Yeah, hunting it now, hopefully I can reproduce and a fix should be 
forth coming.

> This is a 64-way P7 btw, so a nice race-o-matic :-)

It's why we all love ppc :-)

-- 
Jens Axboe

