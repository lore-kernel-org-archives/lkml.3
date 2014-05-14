Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752894AbaENOHl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 10:07:41 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:19090 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750973AbaENOHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 10:07:39 -0400
Message-ID: <537378A0.9060204@fb.com>
Date: Wed, 14 May 2014 08:07:28 -0600
From: Jens Axboe <axboe@fb.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Asai Thambi S P <asamymuthupa@micron.com>,
        Sam Bradshaw <sbradshaw@micron.com>,
        Kent Overstreet <kmo@daterainc.com>,
        Alexander Gordeev <agordeev@redhat.com>,
        <linux-kernel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
Subject: Re: [patch] mtip32xx: blk_mq_init_queue() returns an ERR_PTR
References: <20140514125418.GA14571@mwanda>
In-Reply-To: <20140514125418.GA14571@mwanda>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.96,1.0.14,0.0.0000
 definitions=2014-05-14_03:2014-05-14,2014-05-14,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=1.62457580721309e-09 kscore.compositescore=0
 circleOfTrustscore=36.3013039215409 compositescore=0.99769566186947
 urlsuspect_oldscore=0.99769566186947 suspectscore=0
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=62764
 rbsscore=0.99769566186947 spamscore=0
 recipient_to_sender_domain_totalscore=3 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1405140165
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-05-14 06:54, Dan Carpenter wrote:
> We changed this from blk_alloc_queue_node() to blk_mq_init_queue() so
> the check needs to be updated as well.
>
> Fixes: ee5036035df1 ('mtip32xx: convert to use blk-mq')
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Thanks Dan, applied.

-- 
Jens Axboe

