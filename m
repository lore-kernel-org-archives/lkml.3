Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754389AbaKXSBV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 13:01:21 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:64210 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751530AbaKXSBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 13:01:19 -0500
Date: Mon, 24 Nov 2014 13:01:10 -0500
From: Chris Mason <clm@fb.com>
Subject: Re: [GIT PULL] Btrfs deadlock fix
To: <dsterba@suse.cz>
CC: <torvalds@linux-foundation.org>, <linux-btrfs@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Message-ID: <1416852070.3019.5@mail.thefacebook.com>
In-Reply-To: <20141124173909.GC26471@twin.jikos.cz>
References: <20141123151439.GA16816@ret.masoncoding.com>
	<20141124173909.GC26471@twin.jikos.cz>
X-Mailer: geary/0.8.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
X-Originating-IP: [192.168.16.4]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.28,0.0.0000
 definitions=2014-11-24_02:2014-11-24,2014-11-24,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 kscore.is_bulkscore=0
 kscore.compositescore=0 circleOfTrustscore=3.73027290173794
 compositescore=0.939076664828693 urlsuspect_oldscore=0.939076664828693
 suspectscore=1 recipient_domain_to_sender_totalscore=0 phishscore=0
 bulkscore=0 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=62764
 rbsscore=0.939076664828693 spamscore=0
 recipient_to_sender_domain_totalscore=0 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1411240139
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 24, 2014 at 12:39 PM, David Sterba <dsterba@suse.cz> wrote:
> Hi Chris,
> 
> I thought the fix for the scrub/replace deadlock would be included in
> this pull, I can reproduce it on each run of xfstests with 3.18-rc.
> 
> btrfs: fix dead lock while running replace and defrag concurrently

> https://patchwork.kernel.org/patch/5264531/
> 
> I've retested it again including this pull and still deadlocks 
> reliably
> at btrfs/070.

This wasn't a new problem, so I had it queued for the merge window.

-chris



