Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755918AbaG3UrT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 16:47:19 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:2350 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750990AbaG3UrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 16:47:18 -0400
Message-ID: <53D959D0.1020303@fb.com>
Date: Wed, 30 Jul 2014 16:47:12 -0400
From: Josef Bacik <jbacik@fb.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Nicholas Krause <xerofoify@gmail.com>, <clm@fb.com>
CC: <linux-btrfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Remove certain calls for releasing page cache
References: <1406752954-26158-1-git-send-email-xerofoify@gmail.com>
In-Reply-To: <1406752954-26158-1-git-send-email-xerofoify@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.16.4]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-07-30_07:2014-07-30,2014-07-30,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 kscore.is_bulkscore=0
 kscore.compositescore=0 circleOfTrustscore=1749.24041094204
 compositescore=0.324642340081358 urlsuspect_oldscore=0.324642340081358
 suspectscore=0 recipient_domain_to_sender_totalscore=0 phishscore=0
 bulkscore=0 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=2524143
 rbsscore=0.324642340081358 spamscore=0
 recipient_to_sender_domain_totalscore=0 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1407300242
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30/2014 04:42 PM, Nicholas Krause wrote:
> This patch removes the lines for releasing the page cache in certain
> files as this may aid in perfomance with writes in the compression
> rountines of btrfs. Please note that this patch has not been tested
> on my own hardware due to no compression based btrfs volumes of my
> own.
>

http://37.media.tumblr.com/tumblr_m44v95k9Y11qjhgo6o1_250.gif

Josef
