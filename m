Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754957AbaJNGcG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 02:32:06 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:6559 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754038AbaJNGcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 02:32:04 -0400
Date: Tue, 14 Oct 2014 02:31:52 -0400
From: Chris Mason <clm@fb.com>
Subject: Re: btrfs: kernel BUG at fs/btrfs/extent_io.c:676!
To: Sasha Levin <sasha.levin@oracle.com>
CC: <jbacik@fb.com>, <linux-btrfs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>
Message-ID: <1413268312.2971.1@mail.thefacebook.com>
In-Reply-To: <543B35D3.6050509@oracle.com>
References: <543B35D3.6050509@oracle.com>
X-Mailer: geary/0.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
X-Originating-IP: [192.168.16.4]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.28,0.0.0000
 definitions=2014-10-14_03:2014-10-13,2014-10-14,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=3.73440955603321e-07 kscore.compositescore=0
 circleOfTrustscore=178.203688093279 compositescore=0.9989857498195
 urlsuspect_oldscore=0.9989857498195 suspectscore=0
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=62764
 rbsscore=0.9989857498195 spamscore=0
 recipient_to_sender_domain_totalscore=0 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1410140072
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 12, 2014 at 10:15 PM, Sasha Levin <sasha.levin@oracle.com> 
wrote:
> Ping?
> 
> This BUG_ON()ing due to GFP_ATOMIC allocation failure is really silly 
> :(

Agreed, I have a patch for this in testing.  It didn't make my first 
pull but I'll get it fixed up.

-chris


