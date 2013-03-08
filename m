Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760234Ab3CHCW4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 21:22:56 -0500
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:40897 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760216Ab3CHCWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 21:22:54 -0500
From: Xiangliang Yu <yuxiangl@marvell.com>
To: Bjorn Helgaas <bhelgaas@google.com>,
        "yxlraid@gmail.com" <yxlraid@gmail.com>
CC: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 7 Mar 2013 18:22:10 -0800
Subject: RE: [PATCH 1/2] PCI: define macro for marvell vendor ID
Thread-Topic: [PATCH 1/2] PCI: define macro for marvell vendor ID
Thread-Index: Ac4bUFovSLQCr2OvQ9+9JgwEnVgVVwAUzjPQ
Message-ID: <F766E4F80769BD478052FB6533FA745D25F4368537@SC-VEXCH4.marvell.com>
References: <1362666523-9961-1-git-send-email-yxlraid@gmail.com>
 <CAErSpo69g-dJo4xW+bvGuz=TALfMLQBgQ-_PLvsa-c58AzOVJA@mail.gmail.com>
In-Reply-To: <CAErSpo69g-dJo4xW+bvGuz=TALfMLQBgQ-_PLvsa-c58AzOVJA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r282MvXZ025771

Hi, Bjorn
I will update mvsas and ahci with the macro, just need more time to test it.
Thanks!

> -----Original Message-----
> From: Bjorn Helgaas [mailto:bhelgaas@google.com]
> Sent: 2013Äê3ÔÂ8ÈÕ 0:25
> To: yxlraid@gmail.com
> Cc: linux-pci@vger.kernel.org; linux-kernel@vger.kernel.org; Xiangliang Yu
> Subject: Re: [PATCH 1/2] PCI: define macro for marvell vendor ID
> 
> On Thu, Mar 7, 2013 at 7:28 AM,  <yxlraid@gmail.com> wrote:
> > From: Xiangliang Yu <yuxiangl@marvell.com>
> >
> > Define PCI_VENDOR_MARVELL_ID_EXT macro for 0x1b4b vendor ID
> 
> "PCI_VENDOR_MARVELL_ID_EXT" is not actually the symbol you defined below.
> 
> Per the comment at the top of pci_ids.h, we don't add things here
> unless they are shared between multiple drivers.
> 
> That said, the 0x1b4b vendor ID is used in mv_init.c, mvumi.h,
> mvumi.c, and ahci.c.  If you want to unify all those so they all use
> same symbol, and define that symbol here in pci_ids.h, that would be
> fine with me.
> 
> > ---
> >  include/linux/pci_ids.h |    1 +
> >  1 files changed, 1 insertions(+), 0 deletions(-)
> >
> > diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
> > index f11c1c2..a80f9e6 100644
> > --- a/include/linux/pci_ids.h
> > +++ b/include/linux/pci_ids.h
> > @@ -1604,6 +1604,7 @@
> >  #define PCI_SUBDEVICE_ID_KEYSPAN_SX2   0x5334
> >
> >  #define PCI_VENDOR_ID_MARVELL          0x11ab
> > +#define PCI_VENDOR_ID_MARVELL_EXT      0x1b4b
> >  #define PCI_DEVICE_ID_MARVELL_GT64111  0x4146
> >  #define PCI_DEVICE_ID_MARVELL_GT64260  0x6430
> >  #define PCI_DEVICE_ID_MARVELL_MV64360  0x6460
> > --
> > 1.7.5.4
> >
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
