Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755460Ab3AJX7E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 18:59:04 -0500
Received: from usindpps06.hds.com ([207.126.252.19]:58530 "EHLO
	usindpps06.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754827Ab3AJX7C convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 18:59:02 -0500
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        "Luck, Tony" <tony.luck@intel.com>
CC: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: linux-next: build failure after merge of the ia64 tree
Thread-Topic: linux-next: build failure after merge of the ia64 tree
Thread-Index: AQHN743kTrlGit6eL0ieB0w9IMcxHphDPO8A
Date: Thu, 10 Jan 2013 23:58:53 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D414A3D7E4@USINDEM103.corp.hds.com>
References: <20130111105440.3497d6f8c79189ff6a1bd236@canb.auug.org.au>
In-Reply-To: <20130111105440.3497d6f8c79189ff6a1bd236@canb.auug.org.au>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.74.43.113]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.9.8327,1.0.431,0.0.0000
 definitions=2013-01-10_10:2013-01-10,2013-01-10,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=1 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1211240000
 definitions=main-1301100244
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen, Tony,

I will take a look at it.

Seiji

> -----Original Message-----
> From: Stephen Rothwell [mailto:sfr@canb.auug.org.au]
> Sent: Thursday, January 10, 2013 6:55 PM
> To: Luck, Tony
> Cc: linux-next@vger.kernel.org; linux-kernel@vger.kernel.org; Seiji Aguchi
> Subject: linux-next: build failure after merge of the ia64 tree
> 
> Hi all,
> 
> After merging the ia64 tree, today's linux-next build (x86_64_allmodconfig) failed like this:
> 
> ERROR: "pstore_cannot_block_path" [drivers/firmware/efivars.ko] undefined!
> 
> Caused by commit 1a1df768ea4e ("efi_pstore: Avoid deadlock in non-blocking paths").
> 
> I have used the ia64 tree from next-20130110 for today.
> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
