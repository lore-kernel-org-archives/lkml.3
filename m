Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755804AbaCNUPB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 16:15:01 -0400
Received: from mga02.intel.com ([134.134.136.20]:35690 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753570AbaCNUO7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 16:14:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,656,1389772800"; 
   d="scan'208";a="500187624"
From: "Moore, Robert" <robert.moore@intel.com>
To: "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>
CC: Sabrina Dubroca <sd@queasysnail.net>, "Zheng, Lv" <lv.zheng@intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        Len Brown <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: RE: ACPICA 20140214 auto-serialize weirds my machine...
Thread-Topic: ACPICA 20140214 auto-serialize weirds my machine...
Thread-Index: AQHPP58qJGgIn67g10eWtMCYXVeqCZrhTmWA//+rv9CAAAfVhoAAApog
Date: Fri, 14 Mar 2014 20:14:57 +0000
Message-ID: <94F2FBAB4432B54E8AACC7DFDE6C92E37C7F98B6@ORSMSX103.amr.corp.intel.com>
References: <14866.1394813101@turing-police.cc.vt.edu>
 <20140314173801.GA3755@kria>
            <94F2FBAB4432B54E8AACC7DFDE6C92E37C7F9876@ORSMSX103.amr.corp.intel.com>
 <22867.1394827457@turing-police.cc.vt.edu>
In-Reply-To: <22867.1394827457@turing-police.cc.vt.edu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have reproduced the problem here, and have reached an understanding of the problem.

We are working on the solution, please disable auto-serialize for now.
Thanks,
Bob


> -----Original Message-----
> From: Valdis.Kletnieks@vt.edu [mailto:Valdis.Kletnieks@vt.edu]
> Sent: Friday, March 14, 2014 1:04 PM
> To: Moore, Robert
> Cc: Sabrina Dubroca; Zheng, Lv; Wysocki, Rafael J; Len Brown; linux-
> kernel@vger.kernel.org; linux-acpi@vger.kernel.org
> Subject: Re: ACPICA 20140214 auto-serialize weirds my machine...
> 
> On Fri, 14 Mar 2014 19:36:54 -0000, "Moore, Robert" said:
> > Sabrina, Valdis:
> >
> > Do either of you see any error messages like this:
> >
> > ACPI Error: Mutex [0x1] is not acquired, cannot release
> (20140214/utmutex-437)
> 
> All of my "ACPI Error:" messages look like either:
> 
> ACPI Error: Cannot acquire Mutex for method [SNVC], current SyncLevel is
> too large (1) (20140214/dsmethod-362)
> 
> or
> 
> ACPI Error: Method parse/execution failed [\ECBT] (Node ffff88012d02d588),
> AE_AML_MUTEX_ORDER (20140214/psparse-536)
> 
> I should have a git bisect finished shortly...
