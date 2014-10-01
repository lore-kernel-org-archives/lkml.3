Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752081AbaJAUpe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 16:45:34 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:23738 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751005AbaJAUpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 16:45:32 -0400
Message-ID: <542C67E6.90507@fb.com>
Date: Wed, 1 Oct 2014 14:45:26 -0600
From: Jens Axboe <axboe@fb.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        <xen-devel@lists.xenproject.org>, <linux-kernel@vger.kernel.org>,
        <axboe@kernel.dk>
Subject: Re: [GIT PULL] (xen) stable/for-jens-3.18
References: <20141001203632.GA26119@laptop.dumpdata.com>
In-Reply-To: <20141001203632.GA26119@laptop.dumpdata.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.28,0.0.0000
 definitions=2014-10-01_06:2014-10-01,2014-10-01,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 suspectscore=0 phishscore=0 adultscore=0 bulkscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1410010205
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-10-01 14:36, Konrad Rzeszutek Wilk wrote:
> Hey Jens,
>
> Please pull the following branch:
>
>    git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/for-jens-3.18
>
> which is based on your for-3.18/drivers branch (last commit is
> e9f05b4 drbd: use RB_DECLARE_CALLBACKS() to define augment callbacks).
>
> This pull has two fixes and one cleanup. Nothing earthshattering.

Pulled, thanks.

-- 
Jens Axboe

