Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753485AbaE0U6E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 16:58:04 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:61329 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752215AbaE0U6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 16:58:01 -0400
Message-ID: <5384FC60.1070103@fb.com>
Date: Tue, 27 May 2014 14:58:08 -0600
From: Jens Axboe <axboe@fb.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: blk-mq: refactor request allocation
References: <1401217190-32453-1-git-send-email-hch@lst.de>
In-Reply-To: <1401217190-32453-1-git-send-email-hch@lst.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.96,1.0.14,0.0.0000
 definitions=2014-05-27_05:2014-05-27,2014-05-27,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 suspectscore=0 phishscore=0 adultscore=0 bulkscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1405270286
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/27/2014 12:59 PM, Christoph Hellwig wrote:
> This series streamlines the request allocation path.
> 

Series looks innocuous enough to me, but it's about a 1.5% performance
drop here with an actual device. These tests are very stable, anything
over ~0.1% is definitely outside of noise. I repeated and rebooted a few
times and tested both, it's persistent. No smoking guns in the profile.

