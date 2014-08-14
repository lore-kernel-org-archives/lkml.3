Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754097AbaHNAoO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 20:44:14 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:23857 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752149AbaHNAoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 20:44:12 -0400
Message-ID: <53EC0655.8030600@fb.com>
Date: Wed, 13 Aug 2014 20:44:05 -0400
From: Chris Mason <clm@fb.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>, Josef Bacik <jbacik@fb.com>
CC: <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: new stuff in the btrfs tree
References: <20140814100750.5c6368f1@canb.auug.org.au>
In-Reply-To: <20140814100750.5c6368f1@canb.auug.org.au>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.16.4]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.27,0.0.0000
 definitions=2014-08-13_06:2014-08-13,2014-08-13,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=1.16573417585641e-15 kscore.compositescore=0
 circleOfTrustscore=51.6554285532058 compositescore=0.998981209195878
 urlsuspect_oldscore=0.998981209195878 suspectscore=0
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=64355
 rbsscore=0.998981209195878 spamscore=0
 recipient_to_sender_domain_totalscore=3 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1408140006
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13/2014 08:07 PM, Stephen Rothwell wrote:
> Hi all,
> 
> Are all the commits just added to the btrfs tree really intended for
> v3.17?  If not then please remove them until after v3.17-rc1 is
> released.  If so, then they are very late :-(
> 
> I suspect the latter because some of them seem to date from June (and a
> few even from February).
> 

Hi Stephen,

Yes, these are for 3.17-rc1.  My push to my -next tree was late due to
vacations and because we've been hunting a deadlock in our workqueue
code, but I've had these in testing for some time.

-chris
