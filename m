Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756614AbaKTCf3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 21:35:29 -0500
Received: from mga02.intel.com ([134.134.136.20]:32479 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754658AbaKTCf1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 21:35:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,421,1413270000"; 
   d="scan'208";a="640134121"
From: "Zheng, Lv" <lv.zheng@intel.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "Brown, Len" <len.brown@intel.com>, Lv Zheng <zetalog@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: RE: [PATCH 1/6] ACPI/EC: Introduce STARTED/STOPPED flags to replace
 BLOCKED flag.
Thread-Topic: [PATCH 1/6] ACPI/EC: Introduce STARTED/STOPPED flags to
 replace BLOCKED flag.
Thread-Index: AQHP9yVTyINIm6IIIUqyDtdpynBt3JxRS4XwgBarhsKAAO5owA==
Date: Thu, 20 Nov 2014 02:34:12 +0000
Message-ID: <1AE640813FDE7649BE1B193DEA596E88026A3D9E@SHSMSX101.ccr.corp.intel.com>
References: <cover.1414988981.git.lv.zheng@intel.com>
 <1AE640813FDE7649BE1B193DEA596E8802689778@SHSMSX101.ccr.corp.intel.com>
 <20141118132328.GA27428@node.dhcp.inet.fi>
 <4486101.LWS7CexbAj@vostro.rjw.lan> <20141119121615.GA2514@node.dhcp.inet.fi>
In-Reply-To: <20141119121615.GA2514@node.dhcp.inet.fi>
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

> From: Kirill A. Shutemov [mailto:kirill@shutemov.name]
> Sent: Wednesday, November 19, 2014 8:16 PM
> 
> On Tue, Nov 18, 2014 at 10:20:11PM +0100, Rafael J. Wysocki wrote:
> > On Tuesday, November 18, 2014 03:23:28 PM Kirill A. Shutemov wrote:
> > > On Wed, Nov 05, 2014 at 02:52:36AM +0000, Zheng, Lv wrote:
> >
> > [cut]
> >
> > >
> > > Here's lockdep warning I see on -next:
> >
> > Is patch [1/6] sufficient to trigger this or do you need all [1-4/6]?
> 
> I only saw it on -next. I've tried to apply patches directly on -rc5 and
> don't see the warning. I don't have time for proper bisecting, sorry.

Also I want to know if there is a real dead lock issue triggered?
I think we have worked the dead lock issue around to make it working even when the fix is not merged so that we can have other EC work proceeded.
So maybe I only need to prevent the warning from being triggered at current situation.

Thanks and best regards
-Lv
