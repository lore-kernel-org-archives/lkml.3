Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751263AbaACQHP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 11:07:15 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:44464 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750899AbaACQHM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 11:07:12 -0500
From: Chris Mason <clm@fb.com>
To: "fengguang.wu@intel.com" <fengguang.wu@intel.com>
CC: "jbacik@fusionio.com" <jbacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lkp@linux.intel.com" <lkp@linux.intel.com>
Subject: Re: 1be41b78: +18% increased btrfs write throughput
Thread-Topic: 1be41b78: +18% increased btrfs write throughput
Thread-Index: AQHPCJw4EBmXnMUjt0qDxOSacPU9+JpzsMSA
Date: Fri, 3 Jan 2014 16:07:05 +0000
Message-ID: <1388765265.32640.7.camel@ret.masoncoding.com>
References: <20140103155421.GA7494@localhost>
In-Reply-To: <20140103155421.GA7494@localhost>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.168.57.29]
Content-Type: text/plain; charset="utf-7"
Content-ID: <73283CD1EF725D4A81F7853D2ED5E667@fb.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2014-01-03_06:2014-01-03,2014-01-03,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=1.24235475795764e-08 kscore.compositescore=0
 circleOfTrustscore=288.6538123 compositescore=0.998981209195878
 urlsuspect_oldscore=0.998981209195878 suspectscore=0
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=64355
 rbsscore=0.998981209195878 spamscore=0
 recipient_to_sender_domain_totalscore=2 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1305240000
 definitions=main-1401030093
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-01-03 at 23:54 +-0800, fengguang.wu+AEA-intel.com wrote:
+AD4- Hi Josef,
+AD4- 
+AD4- FYI. We are doing 0day performance tests and happen to notice that
+AD4- btrfs write throughput increased considerably during v3.10-11 time
+AD4- frame:
+AD4- 
+AD4-           v3.10                      v3.11                      v3.12                  v3.13-rc6
+AD4- ---------------  -------------------------  -------------------------  -------------------------
+AD4-      50619 +AH4- 1+ACU-     +-17.0+ACU-      59209 +AH4- 2+ACU-     +-18.8+ACU-      60159 +AH4- 2+ACU-     +-20.5+ACU-      61007 +AH4- 0+ACU-  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-btrfs-1dd
+AD4-      50619          +-17.0+ACU-      59209          +-18.8+ACU-      60159          +-20.5+ACU-      61007       TOTAL iostat.sdd.wkB/s
+AD4- 
+AD4- and it's contributed by 
+AD4- 
+AD4- commit 1be41b78bc688fc634bf30965d2be692c99fd11d
+AD4- Author:     Josef Bacik +ADw-jbacik+AEA-fusionio.com+AD4-
+AD4- AuthorDate: Wed Jun 12 13:56:06 2013 -0400
+AD4- Commit:     Josef Bacik +ADw-jbacik+AEA-fusionio.com+AD4-
+AD4- CommitDate: Mon Jul 1 08:52:28 2013 -0400
+AD4- 
+AD4-     Btrfs: fix transaction throttling for delayed refs

Bonus points for increasing the performance on purpose.  Thanks for
running these Wu.

-chris

