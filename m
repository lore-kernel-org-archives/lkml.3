Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753903AbaJQTdR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 15:33:17 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:45323 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753538AbaJQTdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 15:33:15 -0400
Message-ID: <54416EF6.1050403@fb.com>
Date: Fri, 17 Oct 2014 15:33:10 -0400
From: Josef Bacik <jbacik@fb.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Davidlohr Bueso <dave@stgolabs.net>, LKML <linux-kernel@vger.kernel.org>,
        <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs soft lockups: locks gone crazy
References: <1413271664.27233.13.camel@linux-t7sj.site>
In-Reply-To: <1413271664.27233.13.camel@linux-t7sj.site>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.16.4]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.28,0.0.0000
 definitions=2014-10-17_05:2014-10-17,2014-10-17,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 suspectscore=0 phishscore=0 adultscore=0 bulkscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1410170174
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/2014 03:27 AM, Davidlohr Bueso wrote:
> Hello,
>
> I'm getting massive amounts of cpu soft lockups in Linus's tree for
> today. This occurs almost immediately and is very reproducible in aim7
> disk workloads using btrfs:
>

I'm trying to reproduce but it's not popping for me.  What is the setup 
of your fs?  mkfs options, mount options etc.  And how are you running 
aim7?  I'm using reaim with the default reaim.config and workfile,disk, 
is this what you are using?  If not please attach your config and 
workfile so I can be sure to be doing the same thing as you.  Thanks,

Josef

