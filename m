Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752297Ab3FHLOQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jun 2013 07:14:16 -0400
Received: from mga03.intel.com ([143.182.124.21]:44304 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751861Ab3FHLOO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jun 2013 07:14:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,827,1363158000"; 
   d="scan'208";a="314114518"
From: "Bityutskiy, Artem" <artem.bityutskiy@intel.com>
To: Matt Fleming <matt@console-pimps.org>
CC: Bjorn Helgaas <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "Fleming, Matt" <matt.fleming@intel.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "Seth Forshee" <seth.forshee@canonical.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] x86/PCI: setup data may be in highmem
Thread-Topic: [PATCH] x86/PCI: setup data may be in highmem
Thread-Index: AQHOZDlLDeF6179HgUq2ymywBjlnNQ==
Date: Sat, 8 Jun 2013 11:14:08 +0000
Message-ID: <1370690248.2938.65.camel@sauron.fi.intel.com>
References: <1369215782-32697-1-git-send-email-matt@console-pimps.org>
	 <1370690146.2938.64.camel@sauron.fi.intel.com>
In-Reply-To: <1370690146.2938.64.camel@sauron.fi.intel.com>
Reply-To: "Bityutskiy, Artem" <artem.bityutskiy@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.237.72.81]
Content-Type: text/plain; charset="utf-8"
Content-ID: <8EF7B4BAA407C046B1236F1D710F150E@intel.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r58BENaw027359

On Sat, 2013-06-08 at 14:15 +0300, Artem Bityutskiy wrote:
> On Wed, 2013-05-22 at 10:43 +0100, Matt Fleming wrote:
> > From: Matt Fleming <matt.fleming@intel.com>
> > 
> > pcibios_add_device() assumes that the physical addresses stored in
> > setup_data are accessible via the direct kernel mapping, and that
> > calling phys_to_virt() is valid. This isn't guaranteed to be true on x86
> > where the direct mapping range is much smaller than on x86-64.
> > 
> > Calling phys_to_virt() on a highmem address results in the following,
> 
> Fixes paging request oops for me as well, thanks! Would you please add a
> -stable tag to this patch?

Oh, pardon, you did CC -stable.

-- 
Best Regards,
Artem Bityutskiy
---------------------------------------------------------------------
Intel Finland Oy
Registered Address: PL 281, 00181 Helsinki 
Business Identity Code: 0357606 - 4 
Domiciled in Helsinki 

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
