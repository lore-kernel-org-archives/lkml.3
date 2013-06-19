Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934701Ab3FSP3t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 11:29:49 -0400
Received: from mga11.intel.com ([192.55.52.93]:4980 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934022Ab3FSP3r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 11:29:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,898,1363158000"; 
   d="scan'208";a="356130179"
From: "Brown, Len" <len.brown@intel.com>
To: Ingo Molnar <mingo@kernel.org>, "Luck, Tony" <tony.luck@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>, Borislav Petkov <bp@alien8.de>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>
Subject: RE: [GIT PULL] Some error injection fixes to queue for 3.11
Thread-Topic: [GIT PULL] Some error injection fixes to queue for 3.11
Thread-Index: AQHObORt1ZSLP0h9qU201RCwbN3oWJk9KX8w
Date: Wed, 19 Jun 2013 15:29:36 +0000
Message-ID: <1A7043D5F58CCB44A599DFD55ED4C948385151A1@FMSMSX106.amr.corp.intel.com>
References: <51b20612239358173f@agluck-desk.sc.intel.com>
 <20130619115702.GC10599@gmail.com>
In-Reply-To: <20130619115702.GC10599@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.1.200.106]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+rafael

> Pulled, thanks Tony!
> 
> Len, are you fine with this route [tip:x86/ras tree] for the
> drivers/acpi/apei/einj.c changes?

Yes, the RAS guys basically own that code.

thanks,
-Len


