Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271AbaCaO25 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 10:28:57 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:53666 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753125AbaCaO2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 10:28:54 -0400
Message-ID: <53397B76.8050004@fb.com>
Date: Mon, 31 Mar 2014 08:28:06 -0600
From: Jens Axboe <axboe@fb.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Linux/m68k <linux-m68k@vger.kernel.org>,
        Debian m68k <debian-68k@lists.debian.org>,
        Michael Schmitz <schmitz@debian.org>,
        Michael Schmitz <schmitzmic@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/4] m68k/atari - ataflop: use correct virt/phys translation
 for DMA buffer
References: <1396137686-32678-1-git-send-email-schmitz@debian.org>	<1396137686-32678-4-git-send-email-schmitz@debian.org> <CAMuHMdWFuh5SpiAwp-0-KCnG=NFJT+DamDZUr2tAwdK=FrVW=w@mail.gmail.com>
In-Reply-To: <CAMuHMdWFuh5SpiAwp-0-KCnG=NFJT+DamDZUr2tAwdK=FrVW=w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2014-03-31_02:2014-03-31,2014-03-31,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=3.88578058618805e-15 kscore.compositescore=0
 circleOfTrustscore=0 compositescore=0.324642340081358
 urlsuspect_oldscore=0.324642340081358 suspectscore=0
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=2524143
 rbsscore=0.324642340081358 spamscore=0
 recipient_to_sender_domain_totalscore=0 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1403310061
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31/2014 01:46 AM, Geert Uytterhoeven wrote:
> Hi Jens,
>
> If you don't object, I'd like to take this one through the m68k tree, as it
> depends on a new m68k platform function.

Sure, that's fine.

-- 
Jens Axboe

