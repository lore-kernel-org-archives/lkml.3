Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752876AbbAVGkB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 01:40:01 -0500
Received: from mga03.intel.com ([134.134.136.65]:35818 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750979AbbAVGjz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 01:39:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,447,1418112000"; 
   d="scan'208";a="665651364"
From: "Zheng, Lv" <lv.zheng@intel.com>
To: "Purdila, Octavian" <octavian.purdila@intel.com>
CC: "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "Box, David E" <david.e.box@intel.com>,
        "Moore, Robert" <robert.moore@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Brown, Len" <len.brown@intel.com>
Subject: RE: About 2 ACPICA table patches
Thread-Topic: About 2 ACPICA table patches
Thread-Index: AdAxInxpvXNapHmAS86BpsqdPFELKAAtaNmAAQ152nA=
Date: Thu, 22 Jan 2015 06:39:19 +0000
Message-ID: <1AE640813FDE7649BE1B193DEA596E88026B9F96@SHSMSX101.ccr.corp.intel.com>
References: <1AE640813FDE7649BE1B193DEA596E88026B7CAD@SHSMSX101.ccr.corp.intel.com>
 <CAE1zotJapkp83cSWndWuw5brR-rCZyAyr4a1rJCO3xRucq1-Og@mail.gmail.com>
In-Reply-To: <CAE1zotJapkp83cSWndWuw5brR-rCZyAyr4a1rJCO3xRucq1-Og@mail.gmail.com>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id t0M6e66i025174

Hi, Octavian

> From: Octavian Purdila [mailto:octavian.purdila@intel.com]
> Sent: Saturday, January 17, 2015 2:03 PM
> 
> On Fri, Jan 16, 2015 at 11:44 AM, Zheng, Lv <lv.zheng@intel.com> wrote:
> > Hi, Octavian
> >
> 
> Hi Lv,
> 
> > I noticed there are 2 patches you've sent to the community.
> > But unfortunately I didn't find them in my mailbox.
> > Let me comment you here.
> >
> > https://patchwork.kernel.org/patch/5501621/
> > This patch seem to be correct.
> > But Rafael should merge it directly via Linux because acpi_unload_table_id() is not in the ACPICA upstream.
> 
> OK, thanks for letting me know. Rafel, does the patch look ok to you?
> 
> > We expect the OSPMs to use acpi_unload_parent_table() instead.
> > I have a divergences reduction series to achieve the transition.
> > But they are pending for review for almost half a year.
> > If you have an environment to test.
> > Could you help to test this again?
> > I can prepare the patchset for you.
> >
> 
> Sure, if you can point me to the patch-set I can test it on my setup.

I didn't have environment to test, so let me send it as RFC with some pci-hotplug/ia64 guys Cced...

Thanks
-Lv


> 
> > https://patchwork.kernel.org/patch/5501561/
> > This patch is correct, I've put it in the 201501 ACPICA release materials for review:
> > https://patchwork.kernel.org/patch/5501621/
> > The patch can be found at:
> > https://github.com/zetalog/acpica/commit/281ff873
> > So if it is merged, you'll see it in the upstream after 201501 ACPICA release cycle.
> > And hence Linux trees doesn't need to merge this patch directly.
> >
> 
> Thanks,
> Tavi
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
