Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753306AbaDYJod (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 05:44:33 -0400
Received: from mx0.aculab.com ([213.249.233.131]:54272 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753249AbaDYJoY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 05:44:24 -0400
From: David Laight <David.Laight@ACULAB.COM>
To: "'Yijing Wang'" <wangyijing@huawei.com>,
        Bjorn Helgaas <bhelgaas@google.com>
CC: Tony Luck <tony.luck@intel.com>,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "sparclinux@vger.kernel.org" <sparclinux@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: RE: [PATCH 00/13] Refactor pci_is_brdige() to simplify code
Thread-Topic: [PATCH 00/13] Refactor pci_is_brdige() to simplify code
Thread-Index: AQHPYGiv0jVusWLreUyzlUfzy7AoB5siE9MQ
Date: Fri, 25 Apr 2014 09:42:45 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D0F6FEEB0@AcuExch.aculab.com>
References: <1398417515-8740-1-git-send-email-wangyijing@huawei.com>
In-Reply-To: <1398417515-8740-1-git-send-email-wangyijing@huawei.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.99.200]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s3P9ijTl004987

From: Yijing Wang
> This patchset rename the current pci_is_bridge() to pci_has_subordinate(),
> and introduce a new pci_is_bridge() which determine pci bridge by check
> dev->hdr_type. The new one is more accurate. PCIe Spec define the pci
> device is a bridge by the dev->hdr_type = 0x01 || 0x02.

That is a dangerous rename and is likely to cause difficult to
identify bugs in any code you've missed.

	David

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
