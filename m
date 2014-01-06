Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754519AbaAFONH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 09:13:07 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:21970 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750805AbaAFONF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 09:13:05 -0500
From: Chris Mason <clm@fb.com>
To: "amadvance@gmail.com" <amadvance@gmail.com>
CC: Josef Bacik <jbacik@fb.com>, "neilb@suse.de" <neilb@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [RFC v2 2/2] fs: btrfs: Extends btrfs/raid56 to support up to
 six parities
Thread-Topic: [RFC v2 2/2] fs: btrfs: Extends btrfs/raid56 to support up to
 six parities
Thread-Index: AQHPCsI9913TFH9SH0KIvKvdtkOHbJp4Q4mA
Date: Mon, 6 Jan 2014 14:12:56 +0000
Message-ID: <1389017609.23310.0.camel@ret.masoncoding.com>
References: <1389000716-3274-1-git-send-email-amadvance@gmail.com>
	 <1389000716-3274-3-git-send-email-amadvance@gmail.com>
In-Reply-To: <1389000716-3274-3-git-send-email-amadvance@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.168.57.29]
Content-Type: text/plain; charset="utf-7"
Content-ID: <03D3FBCD996DF84691383E1810360F94@fb.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Spam-Reason: safe
X-FB-Internal: Safe
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2014-01-06_01:2014-01-06,2014-01-05,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-01-06 at 10:31 +-0100, Andrea Mazzoleni wrote:
+AD4- This patch changes btrfs/raid56.c to use the new raid interface and
+AD4- extends its support to an arbitrary number of parities.
+AD4- 
+AD4- More in details, the two faila/failb failure indexes are now replaced
+AD4- with a fail+AFsAXQ- vector that keeps track of up to six failures, and now
+AD4- the new raid+AF8-par() and raid+AF8-rec() functions are used to handle with
+AD4- parity instead of the old xor/raid6 ones.
+AD4- 

Neat.  The faila/failb were always my least favorite part of the btrfs
code +ADs-)  Did you test just raid5/6 or also the higher parity counts?

-chris

