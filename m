Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754470AbaDKCmf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 22:42:35 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:24529 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753692AbaDKCme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 22:42:34 -0400
Message-ID: <53475693.7050609@fb.com>
Date: Thu, 10 Apr 2014 20:42:27 -0600
From: Jens Axboe <axboe@fb.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>
CC: Matias Bjorling <m@bjorling.me>, <linux-kernel@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 3/4] blk-mq: move request structures into struct blk_mq_tags
References: <1396277175-21382-1-git-send-email-hch@lst.de> <1396277175-21382-4-git-send-email-hch@lst.de> <53457404.5070800@fb.com> <20140410100144.GB20342@lst.de>
In-Reply-To: <20140410100144.GB20342@lst.de>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.96,1.0.14,0.0.0000
 definitions=2014-04-11_01:2014-04-11,2014-04-11,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 suspectscore=0 phishscore=0 adultscore=0 bulkscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1404110042
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-04-10 04:01, Christoph Hellwig wrote:
> On Wed, Apr 09, 2014 at 10:23:32AM -0600, Jens Axboe wrote:
>> This should go into block/blk-mq-tag.h.
>
> Ok.
>
>> We might as well leave this, the mtip32xx conversion ends up using it. So
>> if we pull it now, it'll just be reintroduced shortly.
>
> It's back in the latest revision of the patch, just taking a
> struct blk_mq_tag pointer now so that it can be used by SCSI as well.
>
> I've also changed an opencode variant of it to use the helper.

Great. Will you send out an updated patchset?

-- 
Jens Axboe

