Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757897Ab3DXUQy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 16:16:54 -0400
Received: from mga03.intel.com ([143.182.124.21]:43320 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756997Ab3DXUQx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 16:16:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,545,1363158000"; 
   d="scan'208";a="291364100"
From: "Luck, Tony" <tony.luck@intel.com>
To: Jean Delvare <jdelvare@suse.de>
CC: DuanZhenzhong <zhenzhong.duan@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "Yu, Fenghua" <fenghua.yu@intel.com>, "holt@sgi.com" <holt@sgi.com>
Subject: RE: memcpy_fromio in dmi_scan.c
Thread-Topic: memcpy_fromio in dmi_scan.c
Thread-Index: AQHOP/RwacaplR9CdEKkq9gPksW/N5jkWgQAgAHdcQD//5kOoA==
Date: Wed, 24 Apr 2013 20:16:50 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F1EA53DAA@ORSMSX104.amr.corp.intel.com>
References: <1366636689.4503.35.camel@chaos.site>
	 <5175FF0F.9050206@oracle.com> <1366702122.4667.11.camel@chaos.site>
	 <3908561D78D1C84285E8C5FCA982C28F1EA52ED3@ORSMSX104.amr.corp.intel.com>
 <1366831328.4618.476.camel@chaos.site>
In-Reply-To: <1366831328.4618.476.camel@chaos.site>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r3OKH2SO023579

> That being said, "my" SN2 machine was previously running kernel 3.0.34
> which has the old dmi_scan code and it also said "DMI not present or
> invalid." Plus dmidecode fails on this machine with:
>
> /sys/firmware/efi/systab: SMBIOS entry point missing
>
> So it might as well be that DMI support on SN2 was already broken.
> Please let me know your findings on other SN2 machines.

I don't have an sn2 to test. Added Robin Holt to Cc list

-Tony
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
