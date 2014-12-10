Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933282AbaLJVDm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 16:03:42 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:58009 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932527AbaLJVDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 16:03:41 -0500
Message-ID: <5488B52C.1000202@fb.com>
Date: Wed, 10 Dec 2014 14:03:40 -0700
From: Jens Axboe <axboe@fb.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        <linux-kernel@vger.kernel.org>, <xen-devel@lists.xensource.com>
Subject: Re: [GIT PULL] (xen) for-jens-3.19 for v3.19 Xen blkfront driver
 updates.
References: <20141210205726.GA13822@laptop.dumpdata.com>
In-Reply-To: <20141210205726.GA13822@laptop.dumpdata.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2014-12-10_08:2014-12-10,2014-12-10,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 kscore.is_bulkscore=0
 kscore.compositescore=0 circleOfTrustscore=0
 compositescore=0.925924926977281 urlsuspect_oldscore=0.925924926977281
 suspectscore=0 recipient_domain_to_sender_totalscore=0 phishscore=0
 bulkscore=0 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=64355
 rbsscore=0.925924926977281 spamscore=0
 recipient_to_sender_domain_totalscore=0 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1412100198
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2014 01:57 PM, Konrad Rzeszutek Wilk wrote:
> Hey Jens,
> 
> These are two fixes for Xen blkfront. They harden how it deals with
> broken backends.

Pulled, thanks.


-- 
Jens Axboe

