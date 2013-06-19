Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934881Ab3FSQkn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 12:40:43 -0400
Received: from mga03.intel.com ([143.182.124.21]:8153 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934170Ab3FSQkm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 12:40:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,898,1363158000"; 
   d="scan'208";a="319520124"
From: "Luck, Tony" <tony.luck@intel.com>
To: "Brown, Len" <len.brown@intel.com>, Ingo Molnar <mingo@kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>, Borislav Petkov <bp@alien8.de>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>
Subject: RE: [GIT PULL] Some error injection fixes to queue for 3.11
Thread-Topic: [GIT PULL] Some error injection fixes to queue for 3.11
Thread-Index: AQHObORFa9GDP8n+jkOFyme2gAOIipk9nywA//+diaA=
Date: Wed, 19 Jun 2013 16:40:39 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F2DA87F71@ORSMSX106.amr.corp.intel.com>
References: <51b20612239358173f@agluck-desk.sc.intel.com>
 <20130619115702.GC10599@gmail.com>
 <1A7043D5F58CCB44A599DFD55ED4C948385151A1@FMSMSX106.amr.corp.intel.com>
In-Reply-To: <1A7043D5F58CCB44A599DFD55ED4C948385151A1@FMSMSX106.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Pulled, thanks Tony!
>> 
>> Len, are you fine with this route [tip:x86/ras tree] for the
>> drivers/acpi/apei/einj.c changes?
>
> Yes, the RAS guys basically own that code.

These patches also got picked up by Rafael and are in his ACPI tree
too.  I think the patches were applied identically, so there should not
be any merge conflicts when this all comes back together in the 3.11
merge window.

Rafael already had a chat about who will take future apei changes
so that we won't have this happen again.

-Tony
