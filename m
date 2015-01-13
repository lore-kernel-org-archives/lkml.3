Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457AbbAMCfO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 21:35:14 -0500
Received: from mga01.intel.com ([192.55.52.88]:49216 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752115AbbAMCfM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 21:35:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,746,1413270000"; 
   d="scan'208";a="660843116"
From: "Zheng, Lv" <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
CC: "Moore, Robert" <robert.moore@intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        Len Brown <lenb@kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "devel@acpica.org" <devel@acpica.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] acpi: acpica: utstate:  Remove unused function
Thread-Topic: [PATCH] acpi: acpica: utstate:  Remove unused function
Thread-Index: AQHQJs7YZryiKf+MJEWZeU8I23CSpZyxOAXwgABzZACAC7mUoA==
Date: Tue, 13 Jan 2015 02:33:54 +0000
Message-ID: <1AE640813FDE7649BE1B193DEA596E88026AC9F1@SHSMSX101.ccr.corp.intel.com>
References: <1420232480-3252-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <1AE640813FDE7649BE1B193DEA596E88026AACAC@SHSMSX101.ccr.corp.intel.com>
 <3056635.sprz8UnhD7@vostro.rjw.lan>
In-Reply-To: <3056635.sprz8UnhD7@vostro.rjw.lan>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id t0D2ZJTf024980

Hi,

I've added this patch into the 201501 ACPICA materials for review:
https://github.com/acpica/acpica/pull/61
If it is merged, it will appear in Linux kernel after 201501 ACPICA release.
Thanks for reporting.

Best regards
-Lv

> From: Rafael J. Wysocki [mailto:rjw@rjwysocki.net]
> Sent: Tuesday, January 06, 2015 7:30 AM
> 
> On Monday, January 05, 2015 08:39:37 AM Zheng, Lv wrote:
> > Hi, Richard
> >
> > > From: Rickard Strandqvist [mailto:rickard_strandqvist@spectrumdigital.se]
> > > Sent: Saturday, January 03, 2015 5:01 AM
> > >
> > > Remove the function acpi_ut_create_pkg_state_and_push() that is not used anywhere.
> > >
> > > This was partially found by using a static code analysis program called cppcheck.
> >
> > acpi_ut_create_pkg_state_and_push() is not even used in ACPICA.
> > We can remove it now.
> 
> Let's first remove it in upstream ACPICA, then, I suppose.
> 
> 
> --
> I speak only for myself.
> Rafael J. Wysocki, Intel Open Source Technology Center.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
