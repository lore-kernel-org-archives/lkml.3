Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755942AbaCDAcV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 19:32:21 -0500
Received: from mga11.intel.com ([192.55.52.93]:24104 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755343AbaCDAcQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 19:32:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,581,1389772800"; 
   d="scan'208";a="491774550"
From: "Zheng, Lv" <lv.zheng@intel.com>
To: Thomas Renninger <trenn@suse.de>
CC: "Moore, Robert" <robert.moore@intel.com>,
        "Box, David E" <david.e.box@intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "ck@conrad-kostecki.de" <ck@conrad-kostecki.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "devel@acpica.org" <devel@acpica.org>
Subject: RE: [PATCH 2/4] ACPICA: Introduce new acpi_os_physical_table_add OS
 callback
Thread-Topic: [PATCH 2/4] ACPICA: Introduce new acpi_os_physical_table_add
 OS callback
Thread-Index: AQHPNn7ETOONm9s0vUeg3rV5HSj6rprOyM0AgAFK6gA=
Date: Tue, 4 Mar 2014 00:31:57 +0000
Message-ID: <1AE640813FDE7649BE1B193DEA596E88024BD46F@SHSMSX101.ccr.corp.intel.com>
References: <1393608241-31037-1-git-send-email-trenn@suse.de>
 <1393608241-31037-3-git-send-email-trenn@suse.de>
 <1AE640813FDE7649BE1B193DEA596E88024BB021@SHSMSX101.ccr.corp.intel.com>
 <2330411.KHkNc5Vvtq@skinner>
In-Reply-To: <2330411.KHkNc5Vvtq@skinner>
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

Hi,  Thomas

> From: Thomas Renninger [mailto:trenn@suse.de]
> Sent: Monday, March 03, 2014 8:42 PM
> 
> Hi Lv,
> 
> On Monday, March 03, 2014 01:20:31 AM Zheng, Lv wrote:
> > Hi, Thomas
> >
> > I have a patch series that can cleanup the ACPICA table manager, and change
> > the acpi_load_table into the following style:
> 
> Ok. I suggest that:
> 1) If Thomas (Gleixner) or whoever wants to try out or needs it urgently, he
>    can (must) use a recent kernel with my patches applied.
> 2) You continue to get your changes into ACPICA.
>    Eventually or best would be if you add whatever is needed to
>    allow adding of tables as well (which will be there automatically if
>    I understood the description of your changes correctly).
> 3) Either you give it a try yourself or give me short description for
>    what I have to look out for and I can re-post the Linux patches
>    based on your ACPICA changes, once they show up in the Linux kernel.
>    Best give me a ping as soon as I should look at it.

That sounds good.

Or it can be more efficient for productions:
Linux can merge your patches and ACPICA just stop to take them.
This will leave us divergences.
After the table manager cleanups are tested and shipped in the ACPICA repo, the new facilities will automatically be rolled into Linux branches.
Then I can help to reduce the divergences using the new ACPICA facilities.
At that time I may ask whoever that can test to offer help to review the cleanup patch.

Thanks and best regards
-Lv
