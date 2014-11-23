Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751650AbaKWP4l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 10:56:41 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:57147 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751253AbaKWP4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 10:56:39 -0500
Date: Sun, 23 Nov 2014 10:56:27 -0500
From: Chris Mason <clm@fb.com>
Subject: Re: New crashes walking proc with Saturday's git
To: <torvalds@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>
Message-ID: <1416758187.24312.12@mail.thefacebook.com>
In-Reply-To: <20141123010239.GA12691@ret.masoncoding.com>
References: <20141123010239.GA12691@ret.masoncoding.com>
X-Mailer: geary/0.8.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
X-Originating-IP: [192.168.16.4]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.28,0.0.0000
 definitions=2014-11-23_02:2014-11-21,2014-11-23,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=1.65423230669148e-14 kscore.compositescore=0
 circleOfTrustscore=7.0302659978126 compositescore=0.939076664828693
 urlsuspect_oldscore=0.939076664828693 suspectscore=1
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=64355
 rbsscore=0.939076664828693 spamscore=0
 recipient_to_sender_domain_totalscore=0 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1411230134
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 23, 2014 at 10:02 AM, Chris Mason <clm@fb.com> wrote:
> Since it looks like a race between process exit and /proc, I'll try to
> hammer on that for a better reproduction.  But, here's hoping that
> someone has already seen this one:

It falls over in less than 5 minutes with a fork bomb going.  I'll try 
to bisect.

-chris



