Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758047Ab3BKQe7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 11:34:59 -0500
Received: from usindpps06.hds.com ([207.126.252.19]:48167 "EHLO
	usindpps06.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757698Ab3BKQe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 11:34:56 -0500
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: Matt Fleming <matt@console-pimps.org>,
        "Luck, Tony (tony.luck@intel.com)" <tony.luck@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "mikew@google.com" <mikew@google.com>,
        "cbouatmailru@gmail.com" <cbouatmailru@gmail.com>,
        "dzickus@redhat.com" <dzickus@redhat.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: RE: [PATCH v5 -next 1/2]efivars: Disable external interrupt while
 holding efivars->lock
Thread-Topic: [PATCH v5 -next 1/2]efivars: Disable external interrupt while
 holding efivars->lock
Thread-Index: Ac35y4kVXbvpbEQmTya72C6hOhAdgANXsiMAAFKsUaA=
Date: Mon, 11 Feb 2013 16:34:33 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D414A8FFF2@USINDEM103.corp.hds.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D414A541B5@USINDEM103.corp.hds.com>
 <1360440158.7515.321.camel@mfleming-mobl1.ger.corp.intel.com>
In-Reply-To: <1360440158.7515.321.camel@mfleming-mobl1.ger.corp.intel.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.74.73.11]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.9.8327,1.0.431,0.0.0000
 definitions=2013-02-11_03:2013-02-11,2013-02-11,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=1 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1211240000
 definitions=main-1302110144
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r1BGZ0da017241

Matt,

> Acked-by: Matt Fleming <matt.fleming@intel.com>
> 
> Tony, are you picking this up?

Thank you for reviewing and acking my patchset.

Tony,

This patchset can't be applied to a latest next tree due to following commits.
I will post v6 shortly to fit the latest next tree.
Then, please apply it.

efi: Make 'efi_enabled' a function to query EFI facilities
commit 83e68189745ad931c2afd45d8ee3303929233e7f

efivarfs: Delete dentry from dcache in efivarfs_file_write()
commit  791eb564d218dabe0f9a2212916fe54240b97afb

Seiji
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
