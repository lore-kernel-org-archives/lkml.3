Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751764AbaJAOQl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 10:16:41 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:13151 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751214AbaJAOQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 10:16:40 -0400
Message-ID: <542C0CC2.7060501@fb.com>
Date: Wed, 1 Oct 2014 08:16:34 -0600
From: Jens Axboe <axboe@fb.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>,
        <akpm@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [RESEND] block: hd: remove deprecated IRQF_DISABLED
References: <1395129815-17661-1-git-send-email-michael.opdenacker@free-electrons.com> <1412158027-7094-1-git-send-email-michael.opdenacker@free-electrons.com>
In-Reply-To: <1412158027-7094-1-git-send-email-michael.opdenacker@free-electrons.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.28,0.0.0000
 definitions=2014-10-01_06:2014-10-01,2014-10-01,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 suspectscore=0 phishscore=0 adultscore=0 bulkscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1410010145
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-10-01 04:07, Michael Opdenacker wrote:
> This patch removes the use of the IRQF_DISABLED flag
> from drivers/block/hd.c
>
> It's a NOOP since 2.6.35 and it will be removed one day.
>
> This also removes a related comment which is obsolete too.

Thanks, applied.

-- 
Jens Axboe

