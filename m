Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754930Ab3ALEkY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 23:40:24 -0500
Received: from usindpps03.hds.com ([207.126.252.16]:39588 "EHLO
	usindpps03.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753667Ab3ALEkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 23:40:23 -0500
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: Anton Vorontsov <anton@enomsg.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Luck, Tony (tony.luck@intel.com)" <tony.luck@intel.com>,
        "dzickus@redhat.com" <dzickus@redhat.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: RE: [PATCH v4 0/2] pstore,efi_pstore: Avoid deadlock in
 non-blocking paths
Thread-Topic: [PATCH v4 0/2] pstore,efi_pstore: Avoid deadlock in
 non-blocking paths
Thread-Index: Ac3wJak6dWFNaYOlQSuov+JgTCKuswAemW4AAAhiqrA=
Date: Sat, 12 Jan 2013 04:39:58 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D414A3E721@USINDEM103.corp.hds.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D414A3E17B@USINDEM103.corp.hds.com>
 <20130112033729.GA27214@lizard.sbx05280.losalca.wayport.net>
In-Reply-To: <20130112033729.GA27214@lizard.sbx05280.losalca.wayport.net>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.74.43.113]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.9.8327,1.0.431,0.0.0000
 definitions=2013-01-12_02:2013-01-11,2013-01-12,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=1 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1211240000
 definitions=main-1301110337
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r0C4eRDb024381

Anton,

V3 patch caused a build failure in Linux-next tree.
So, I updated to v4 patch.
Tony already applied the latest one.

You don't need to do anything.
And  I'm sorry for the confusion.

Seiji

<snip>
-----Original Message-----
From: Stephen Rothwell [mailto:sfr@canb.auug.org.au] 
Sent: Thursday, January 10, 2013 6:55 PM
To: Luck, Tony
Cc: linux-next@vger.kernel.org; linux-kernel@vger.kernel.org; Seiji Aguchi
Subject: linux-next: build failure after merge of the ia64 tree

Hi all,

After merging the ia64 tree, today's linux-next build (x86_64_allmodconfig) failed like this:

ERROR: "pstore_cannot_block_path" [drivers/firmware/efivars.ko] undefined!

Caused by commit 1a1df768ea4e ("efi_pstore: Avoid deadlock in non-blocking paths").

I have used the ia64 tree from next-20130110 for today.
--
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
<snip>

> -----Original Message-----
> From: Anton Vorontsov [mailto:anton@scarybugs.org] On Behalf Of Anton Vorontsov
> Sent: Friday, January 11, 2013 10:38 PM
> To: Seiji Aguchi
> Cc: linux-kernel@vger.kernel.org; Luck, Tony (tony.luck@intel.com); dzickus@redhat.com; dle-develop@lists.sourceforge.net; Satoru
> Moriya
> Subject: Re: [PATCH v4 0/2] pstore,efi_pstore: Avoid deadlock in non-blocking paths
> 
> On Fri, Jan 11, 2013 at 06:08:52PM +0000, Seiji Aguchi wrote:
> > Changelog
> > v3 -> v4
> 
> I am confused. Tony already applied v3, no? Do you expect me to do anything with these patches, or is it just an update for Tony?
> 
> Thanks,
> Anton
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
