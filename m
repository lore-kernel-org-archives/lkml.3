Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933416AbaDBVuI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 17:50:08 -0400
Received: from mga01.intel.com ([192.55.52.88]:17618 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933285AbaDBVuG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 17:50:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,782,1389772800"; 
   d="scan'208";a="513208182"
From: "Brown, Len" <len.brown@intel.com>
To: "Gortmaker, Paul (Wind River)" <paul.gortmaker@windriver.com>
CC: "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        Arne Bockholdt <linux-kernel@bockholdt.com>,
        Jiang Liu <jiang.liu@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: Regression in intel_idle on Avaton/Rangely Mohon Peak board
Thread-Topic: Regression in intel_idle on Avaton/Rangely Mohon Peak board
Thread-Index: AQHPTdaFVLQYzxSM7EqDlaR4cHXJtZr9TPjAgACV1ICAAPwfYA==
Date: Wed, 2 Apr 2014 21:50:03 +0000
Message-ID: <1A7043D5F58CCB44A599DFD55ED4C948452FDAA3@FMSMSX106.amr.corp.intel.com>
References: <533B0288.2020304@windriver.com>
 <1A7043D5F58CCB44A599DFD55ED4C948452FD582@FMSMSX106.amr.corp.intel.com>
 <20140401234612.GA22782@windriver.com>
In-Reply-To: <20140401234612.GA22782@windriver.com>
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

> > I'd be interested in the acpi_idle output above for both the
> > new and old boards to see if they are exporting different states
> > on the two boards.
> 
> Could be ; I can probably get access to the newer one again too, if
> that will be useful.

yes, please.

> >
> > dmidecode isn't useful in this case.  The CPUID in /proc/cpuinfo
> > may be useful if the problem turns out to be associated with
> > some stepping.
> 
> The dmidecode info I'd posted indicated that the steppings were
> unnchanged.  I can get the /proc/cpuinfo tomorrow, but I figured
> the dmidecode stepping info was accurate.  Is it not reliable?


DMI is useful to get the BIOS version string, not much else.
Here you want the output from the CPUID instruction,
which is displayed as family/model/stepping in /proc/cpuinfo

thanks,
-Len

