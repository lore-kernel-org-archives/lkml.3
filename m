Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758017AbaKUBih (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 20:38:37 -0500
Received: from mga14.intel.com ([192.55.52.115]:48490 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756904AbaKUBid convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 20:38:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="419604589"
From: "Zheng, Lv" <lv.zheng@intel.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
CC: Lv Zheng <zetalog@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "Brown, Len" <len.brown@intel.com>
Subject: RE: [RFC PATCH v4] ACPICA/Events: Add support to ensure GPE is
 disabled by default for handlers.
Thread-Topic: [RFC PATCH v4] ACPICA/Events: Add support to ensure GPE is
 disabled by default for handlers.
Thread-Index: AQHQBI2TEyXhuOlswEmYCNoDLZLxDJxpEhsAgAB9sICAAL2wcA==
Date: Fri, 21 Nov 2014 01:36:42 +0000
Message-ID: <1AE640813FDE7649BE1B193DEA596E88026A41BB@SHSMSX101.ccr.corp.intel.com>
References: <20141119121615.GA2514@node.dhcp.inet.fi>
 <ce3ab540463bc5d97e527f24ca7d7d82b2952fae.1416459350.git.lv.zheng@intel.com>
 <1AE640813FDE7649BE1B193DEA596E88026A3E81@SHSMSX101.ccr.corp.intel.com>
 <20141120221535.GA13547@node.dhcp.inet.fi>
In-Reply-To: <20141120221535.GA13547@node.dhcp.inet.fi>
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

This result convinces me that this might only be a theoretical dead lock for now.
So finally we won't need this in order to eliminate this warning.

Thanks and best regards
-Lv

> From: Kirill A. Shutemov [mailto:kirill@shutemov.name]
> Sent: Friday, November 21, 2014 6:16 AM
> To: Zheng, Lv
> Cc: Lv Zheng; linux-kernel@vger.kernel.org; linux-acpi@vger.kernel.org; Wysocki, Rafael J; Brown, Len
> Subject: Re: [RFC PATCH v4] ACPICA/Events: Add support to ensure GPE is disabled by default for handlers.
> 
> On Thu, Nov 20, 2014 at 06:47:16AM +0000, Zheng, Lv wrote:
> > Hi, Kirill
> >
> > Could also help to confirm if this patch can also fix the issue.
> > Please help to validate the 2 fix patchsets separately.
> 
> I've applied it on top of other two and still set the issue.
> --
>  Kirill A. Shutemov
