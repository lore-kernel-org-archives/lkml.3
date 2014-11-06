Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751334AbaKFBtj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 20:49:39 -0500
Received: from mga02.intel.com ([134.134.136.20]:34110 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750883AbaKFBti (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 20:49:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,323,1413270000"; 
   d="scan'208";a="603165150"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Barto <mister.freeman@laposte.net>,
        "Tejun Heo (tj@kernel.org)" <tj@kernel.org>
CC: "Lu, Aaron" <aaron.lu@intel.com>, Tejun Heo <tj@kernel.org>,
        "Rafael Wysocki" <rjw@rjwysocki.net>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] PCI: Do not enable async suspend for JMicron chips
Thread-Topic: [PATCH] PCI: Do not enable async suspend for JMicron chips
Thread-Index: AQHP+SJ99LB9XnS4YkW20ZDpwHx2W5xR2T+AgAAEz4CAAPTycA==
Date: Thu, 6 Nov 2014 01:48:06 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A01EB7713@SHSMSX101.ccr.corp.intel.com>
References: <1415151063-2530-1-git-send-email-chuansheng.liu@intel.com>
 <CAErSpo6cWP2ngErLVzqASkeQOLsB7JjgCC8UuA-S=Lz=AJyf6Q@mail.gmail.com>
 <545A7087.3050802@laposte.net>
 <CAErSpo4fvoeP9Gab1ZDg=ofjH+aqxGD09nLDTF1ZERnH=yEPxw@mail.gmail.com>
In-Reply-To: <CAErSpo4fvoeP9Gab1ZDg=ofjH+aqxGD09nLDTF1ZERnH=yEPxw@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sA61niGE031532

Hello Bjorn,

> -----Original Message-----
> From: Bjorn Helgaas [mailto:bhelgaas@google.com]
> Sent: Thursday, November 06, 2014 3:04 AM
> To: Barto
> Cc: Liu, Chuansheng; Lu, Aaron; Tejun Heo; Rafael Wysocki;
> linux-pci@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] PCI: Do not enable async suspend for JMicron chips
> 
> On Wed, Nov 5, 2014 at 11:46 AM, Barto <mister.freeman@laposte.net>
> wrote:
> > this patch solves these 2 bug reports :
> >
> > https://bugzilla.kernel.org/show_bug.cgi?id=84861
> >
> > https://bugzilla.kernel.org/show_bug.cgi?id=81551
> 
> Those bugs were already mentioned.  But e6b7e41cdd8c claims to solve
> https://bugzilla.kernel.org/show_bug.cgi?id=81551, and 84861 is a
> duplicate of 81551, so it should also be fixed by e6b7e41cdd8c.
> 
> So the question is, why was e6b7e41cdd8c insufficient?  Presumably it
> was tested and somebody thought it did fix the problem.

The first patch e6b7e41cdd8c which is just exclude some of JMicron chips(363/361) out of async_suspend,
then Barto found the same issue on JMicron 368, so we need one more general patch to let JMicron chips
out of async_suspend, so we make this patch.

Bjorn, tj,
Could you kindly take this patch? As Barto said, it effected the user experience indeed, thanks.

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
