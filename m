Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752340AbbASPuY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 10:50:24 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:9519 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751430AbbASPuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 10:50:23 -0500
Date: Mon, 19 Jan 2015 10:50:11 -0500
From: Chris Mason <clm@fb.com>
Subject: Re: linux-next: build warning after merge of the akpm-current tree
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Andrew Morton <akpm@linux-foundation.org>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Message-ID: <1421682611.25503.0@mail.thefacebook.com>
In-Reply-To: <20150119184559.0157fa2e@canb.auug.org.au>
References: <20150119184559.0157fa2e@canb.auug.org.au>
X-Mailer: geary/0.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
X-Originating-IP: [192.168.16.4]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2015-01-19_02:2015-01-19,2015-01-19,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 suspectscore=0 phishscore=0 adultscore=0 bulkscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1501190158
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, Jan 19, 2015 at 2:45 AM, Stephen Rothwell 
<sfr@canb.auug.org.au> wrote:
> Hi Andrew,
> 
> After merging the akpm-current tree, today's linux-next build (x86_64
> allmodconfig) produced this warning:
> 
> fs/eventfd.c: In function 'eventfd_poll':
> fs/eventfd.c:121:16: warning: unused variable 'flags' 
> [-Wunused-variable]
>   unsigned long flags;
>                 ^
> 
> Introduced by commit a90de8a54127 ("eventfd: don't take the spinlock 
> in
> eventfd_poll").


Whoops, I'll send a v2.

-chris



