Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760754Ab3D3Oyl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 10:54:41 -0400
Received: from usindpps03.hds.com ([207.126.252.16]:34585 "EHLO
	usindpps03.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758065Ab3D3Oyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 10:54:39 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: Matt Fleming <matt.fleming@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@kernel.org" <mingo@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "mjg59@srcf.ucam.org" <mjg59@srcf.ucam.org>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "jk@ozlabs.org" <jk@ozlabs.org>, "teg@jklm.no" <teg@jklm.no>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mikew@google.com" <mikew@google.com>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: RE: [tip:x86/efi2] efivars: efivar_entry API
Thread-Topic: [tip:x86/efi2] efivars: efivar_entry API
Thread-Index: AQHOPHFEzrlus8pItEq77hQ4E6Icb5jorw2QgAZGhoD///I/MA==
Date: Tue, 30 Apr 2013 14:53:54 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D41AFE207E@USINDEM103.corp.hds.com>
References: <tip-e14ab23dde12b80db4c94b684a2e485b72b16af3@git.kernel.org>
 <A5ED84D3BB3A384992CBB9C77DEDA4D41AFD20E4@USINDEM103.corp.hds.com>
 <517FAAA3.50303@intel.com>
In-Reply-To: <517FAAA3.50303@intel.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.74.73.11]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 mx ip4:207.126.244.0/26 ip4:207.126.252.0/25 include:mktomail.com
 ~all
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.10.8626,1.0.431,0.0.0000
 definitions=2013-04-30_07:2013-04-30,2013-04-30,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=2 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1211240000
 definitions=main-1304300120
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r3UEsrmd024208

I confirmed that efi_pstore_read() and efi_pstore_erase() work correctly.
Please feel free to add

Tested-by: Seiji Aguchi <seiji.aguchi@hds.com>

> -----Original Message-----
> From: Matt Fleming [mailto:matt.fleming@intel.com]
> Sent: Tuesday, April 30, 2013 7:28 AM
> To: Seiji Aguchi
> Cc: linux-kernel@vger.kernel.org; mingo@kernel.org; hpa@zytor.com; mjg59@srcf.ucam.org; tony.luck@intel.com; jk@ozlabs.org;
> teg@jklm.no; tglx@linutronix.de; mikew@google.com; linux-tip-commits@vger.kernel.org
> Subject: Re: [tip:x86/efi2] efivars: efivar_entry API
> 
> On 26/04/13 16:43, Seiji Aguchi wrote:
> > I tested pstore_read() as well.
> > And /dev/pstore/dmesg-efi-X was empty....
> >
> > This must be __efivar_entry_get() instead of __efivar_entry_size().
> > (We may have to introduce _efivar_entry_get_locked() to avoid deadlock.)
> >
> > I think it is a final bug report related to this new API patch.
> 
> Can you try the 'efi-for-tip-fixes' branch at,
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git
> 
> and see if your problems are solved?
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
