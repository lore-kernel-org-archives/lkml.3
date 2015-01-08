Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757148AbbAHU40 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 15:56:26 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:49283 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752141AbbAHU4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 15:56:24 -0500
Message-ID: <54AEEEF3.8040300@fb.com>
Date: Thu, 8 Jan 2015 13:56:19 -0700
From: Jens Axboe <axboe@fb.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Boaz Harrosh <boaz@plexistor.com>, Matthew Wilcox <willy@linux.intel.com>,
        Dmitry Monakhov <dmonakhov@openvz.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCHSET 0/4 v4] brd: partition fixes
References: <54AD5893.9040701@plexistor.com>
In-Reply-To: <54AD5893.9040701@plexistor.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.16.4]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2015-01-08_06:2015-01-07,2015-01-08,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=1.33226762955019e-15 kscore.compositescore=0
 circleOfTrustscore=0 compositescore=0.925924926977281
 urlsuspect_oldscore=0.925924926977281 suspectscore=0
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=62764
 rbsscore=0.925924926977281 spamscore=0
 recipient_to_sender_domain_totalscore=0 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1501080195
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/2015 09:02 AM, Boaz Harrosh wrote:
> Jens Hi
> 
> Currently brd has multiple bugs when trying to use partitions. After this
> set all known problems are solved. Please see individual patch for description
> of the problem.
> (Another merge window, another patchset send. I wish you would tell me to
>  just *uck-off, instead of this silence. What is so big a deal about this
>  simple bug fixes.)

Calm down. All previous series posted have needed changes. And you
always seem to post after a merge window has closed, so your timing is
bad. Finally looks like it's good to go, so I've merged it for this series.

-- 
Jens Axboe

