Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751887AbaKXCrw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 21:47:52 -0500
Received: from mga11.intel.com ([192.55.52.93]:41186 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750989AbaKXCru convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 21:47:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="420602238"
From: "Zheng, Lv" <lv.zheng@intel.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
CC: "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Lv Zheng (zetalog@gmail.com)" <zetalog@gmail.com>
Subject: RE: [UPDATE RFC PATCH 2] ACPICA: Events: Introduce
 ACPI_GPE_HANDLER_RAW to fix 2 issues for the current GPE APIs.
Thread-Topic: [UPDATE RFC PATCH 2] ACPICA: Events: Introduce
 ACPI_GPE_HANDLER_RAW to fix 2 issues for the current GPE APIs.
Thread-Index: AQHQBSYhRzlAGri28kme8Fqqv9om0ZxqQxMwgAA9RACABIXEoA==
Date: Mon, 24 Nov 2014 02:47:45 +0000
Message-ID: <1AE640813FDE7649BE1B193DEA596E88026A46B1@SHSMSX101.ccr.corp.intel.com>
References: <1416531434-3454-1-git-send-email-lv.zheng@intel.com>
 <1AE640813FDE7649BE1B193DEA596E88026A417D@SHSMSX101.ccr.corp.intel.com>
 <20141121124048.GA17006@node.dhcp.inet.fi>
In-Reply-To: <20141121124048.GA17006@node.dhcp.inet.fi>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Adding people that were disturbed by my fault previously.

You should also reply in the same thread with this validation result.
As we might need this to be the motivation for the proposal that the GPE dead lock issue should be fixed in a higher priority way.
I've reported this at:
https://bugs.acpica.org/show_bug.cgi?id=1100

Thanks and best regards
-Lv

> From: Kirill A. Shutemov [mailto:kirill@shutemov.name]
> Sent: Friday, November 21, 2014 8:41 PM
> 
> On Fri, Nov 21, 2014 at 01:05:40AM +0000, Zheng, Lv wrote:
> > Hi, Kirill
> >
> > Please help to check again to use the updated patch.
> > Sorry for my mistake.
> >
> > I originally used a patch that will unlock before invoking all handlers.
> > But as requested by maintainers, the new ACPICA part will use a ACPI_GPE_HANDLER_RAW flag, and I updated my patch in a hurry
> for you without updating the ec.c.
> >
> > It's my fault.
> > I can also do some local confirmation before disturbing you.
> > Could you tell me how can I reproduce this?
> 
> This one seems works
> 
> --
>  Kirill A. Shutemov
