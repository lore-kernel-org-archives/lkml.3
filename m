Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756751AbaDBAQ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 20:16:59 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:44048 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751419AbaDBAQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 20:16:57 -0400
Message-ID: <533B5701.4030303@fb.com>
Date: Tue, 1 Apr 2014 20:17:05 -0400
From: Chris Mason <clm@fb.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <t-itoh@jp.fujitsu.com>
Subject: Re: [GIT PULL] Btrfs pull -- part 1
References: <533ACC62.1080701@fb.com>
In-Reply-To: <533ACC62.1080701@fb.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.16.4]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2014-04-01_07:2014-04-01,2014-04-01,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=2.17048601314218e-14 kscore.compositescore=0
 circleOfTrustscore=17.3681406164796 compositescore=0.998049563855454
 urlsuspect_oldscore=0.998049563855454 suspectscore=0
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=64355
 rbsscore=0.998049563855454 spamscore=0
 recipient_to_sender_domain_totalscore=0 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1404010141
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 04/01/2014 10:25 AM, Chris Mason wrote:
> Hi Linus,
>
> We still have some corruption fixes and other patches coming in for the
> merge window, but this batch is tested and ready to go.
>
> Please pull from:
>
> git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git master

Tsutomu noticed I put the wrong branch name in.  I've pushed my 
for-linus over to my master branch so they all match the shortlog and 
diffstat below.

Thanks,
Chris

