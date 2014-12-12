Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759139AbaLLTdK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 14:33:10 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:57857 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755540AbaLLTdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 14:33:09 -0500
Date: Fri, 12 Dec 2014 14:33:00 -0500
From: Chris Mason <clm@fb.com>
Subject: Re: [GIT PULL] Btrfs for 3.19-rc
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Message-ID: <1418412780.4845.22@mail.thefacebook.com>
In-Reply-To: <CA+55aFzWDZ+3sAHHhZ_iourYAmh_3rfEk-u8H4d4b9=KcJb2gg@mail.gmail.com>
References: <20141212190731.GB23804@ret.masoncoding.com>
	<CA+55aFzWDZ+3sAHHhZ_iourYAmh_3rfEk-u8H4d4b9=KcJb2gg@mail.gmail.com>
X-Mailer: geary/0.8.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
X-Originating-IP: [192.168.16.4]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2014-12-12_07:2014-12-12,2014-12-12,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 kscore.is_bulkscore=0
 kscore.compositescore=0 circleOfTrustscore=29.4129509548051
 compositescore=0.939076664828693 urlsuspect_oldscore=0.939076664828693
 suspectscore=0 recipient_domain_to_sender_totalscore=0 phishscore=0
 bulkscore=0 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=64355
 rbsscore=0.939076664828693 spamscore=0
 recipient_to_sender_domain_totalscore=0 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1412120178
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, Dec 12, 2014 at 2:24 PM, Linus Torvalds 
<torvalds@linux-foundation.org> wrote:
> On Fri, Dec 12, 2014 at 11:07 AM, Chris Mason <clm@fb.com> wrote:
>> 
>>  From a feature point of view, most of the code here comes from Miao 
>> Xie
>>  and others at Fujitsu to implement scrubbing and replacing devices 
>> on
>>  raid56.  This has been in development for a while, and it's a big
>>  improvement.
> 
> So this has probably happened before, and I just haven't been looking,
> but I thought I'd mention it.
> 
> There are merges from github for this feature, and those merges aren't
> signed, and don't have merge messages. Maybe you actually verified all
> of it other ways, but there's no sign of it. I generally push back on
> merging unsigned stuff from random hosting places (to the point where
> I just refuse to do it, although it's possible that some pass though
> just due to inattention), and I think that's just good practice in
> general. And merges that don't explain what the merge does are just
> bad merges (they are extra annoying when they are back-merges, but
> it's a problem even otherwise).

Thanks, in this case he also posted the patches to the btrfs list.  
Using git pull is easier for all the obvious reasons, so I took the 
github tree.  It definitely looked right to me, but I'll compare the 
github code with his patches directly on top of rc6.

Next time I'll make sure they are signed though.

-chris

