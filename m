Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754370AbaHNSRw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 14:17:52 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:48851 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753758AbaHNSRu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 14:17:50 -0400
Message-ID: <53ECFD4A.9030704@fb.com>
Date: Thu, 14 Aug 2014 14:17:46 -0400
From: Chris Mason <clm@fb.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Btrfs
References: <53ECF8FB.1070106@fb.com> <CA+55aFwx1uPDngB5cASUQsfazt0Ry6yxd5aUuSRMawozj26vVA@mail.gmail.com>
In-Reply-To: <CA+55aFwx1uPDngB5cASUQsfazt0Ry6yxd5aUuSRMawozj26vVA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.16.4]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.27,0.0.0000
 definitions=2014-08-14_05:2014-08-14,2014-08-14,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=4.74060957156297e-10 kscore.compositescore=0
 circleOfTrustscore=29.4129509548051 compositescore=0.998049563855454
 urlsuspect_oldscore=0.998049563855454 suspectscore=0
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=64355
 rbsscore=0.998049563855454 spamscore=0
 recipient_to_sender_domain_totalscore=0 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1408140213
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/14/2014 02:10 PM, Linus Torvalds wrote:
> On Thu, Aug 14, 2014 at 11:59 AM, Chris Mason <clm@fb.com> wrote:
>> Hi Linus,
>>
>> Please pull my for-linus branch:
> 
> Yeah, I think this will be for the next merge window.
> 
> This clearly got rebased today. At the end of the merge window. After
> I told people that I was traveling, and asked people to send big
> things early.
> 

[ resend with full cc ]

Hi Linus,

This did get rebased this week (two days ago), but I've been running it
through tests for some time.  It was delayed by my own schedule problems
(vacation and others) that made it very difficult for me to have it
ready early in the window.

Aside from a small number of cleanup patches, these are all fixes.  I'm
happy to pull out the cleanups and focus on the fixes.

-chris
