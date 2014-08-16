Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751598AbaHPQqt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2014 12:46:49 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:50544 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751516AbaHPQqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2014 12:46:47 -0400
Message-ID: <53EF8AF2.2070605@fb.com>
Date: Sat, 16 Aug 2014 12:46:42 -0400
From: Chris Mason <clm@fb.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Smaller btrfs pull
References: <53EE42A9.7000607@fb.com> <CA+55aFz-aSbmLoZv=CGY1bXpQ1zE935-FjTLMZF5=5hteyf9kg@mail.gmail.com>
In-Reply-To: <CA+55aFz-aSbmLoZv=CGY1bXpQ1zE935-FjTLMZF5=5hteyf9kg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.16.4]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.27,0.0.0000
 definitions=2014-08-16_02:2014-08-15,2014-08-16,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=3.84692278032617e-14 kscore.compositescore=0
 circleOfTrustscore=29.4129509548051 compositescore=0.998049563855454
 urlsuspect_oldscore=0.998049563855454 suspectscore=0
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=64355
 rbsscore=0.998049563855454 spamscore=0
 recipient_to_sender_domain_totalscore=0 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1408160221
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/16/2014 11:11 AM, Linus Torvalds wrote:
> On Fri, Aug 15, 2014 at 11:26 AM, Chris Mason <clm@fb.com> wrote:
>>
>> I've been running xfstests with these against your current git
>> overnight, but I'm queueing up longer tests as well.  I understand
>> you may want to wait until rc2, but either way I'll get a sane queue
>> into my linux-next branch for the rest of the rcs.
> 
> You completely mis-understand.
> 
> If something isn't appropriate for the merge window, then it sure as
> HELL isn't appropriate for later rc's either.
> 
> So I'm not going to pull some "stragglers" later and just pull some
> initial stuff now. That's not how this works.

Hi Linus,

Sorry that I wasn't clear.  I had already pushed 1/2 of the commits off
to the 3.18 merge window.  Of the remaining commits, my plan was to send
the fixes that would qualify for rc2 or rc3 during those rcs.

I was trying to say that I fully expected these patches to be closely
inspected.  I'll bring my white gloves.

-chris
