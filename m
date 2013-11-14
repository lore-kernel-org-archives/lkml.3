Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754995Ab3KNXjx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 18:39:53 -0500
Received: from mga09.intel.com ([134.134.136.24]:53230 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752815Ab3KNXjq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 18:39:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="435509130"
From: "Luck, Tony" <tony.luck@intel.com>
To: David Rientjes <rientjes@google.com>
CC: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        Chen Gong <gong.chen@linux.intel.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [patch x86/mce] ACPI, x86: Export boot_cpu_physical_apicid to
 modules
Thread-Topic: [patch x86/mce] ACPI, x86: Export boot_cpu_physical_apicid to
 modules
Thread-Index: AQHO4Y4NBW/b3dchAkqmOAl2WwcKZJolXB6ggACKvYD//3tHMA==
Date: Thu, 14 Nov 2013 23:39:45 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F31D6D6F0@ORSMSX106.amr.corp.intel.com>
References: <alpine.DEB.2.02.1311141504080.30112@chino.kir.corp.google.com>
 <3908561D78D1C84285E8C5FCA982C28F31D6D644@ORSMSX106.amr.corp.intel.com>
 <alpine.DEB.2.02.1311141528180.8370@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1311141528180.8370@chino.kir.corp.google.com>
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

> Or do some randconfig testing before patches are proposed :)  I don't have 
> any particular dependency on this, so I'm happy with whatever is decided.  
> This is the last error I've found related to CONFIG_ACPI_EXTLOG, however.

If you *promise* this is the last one ,.. then

Acked-by: Tony Luck <tony.luck@intel.com>

-Tony
