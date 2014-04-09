Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964834AbaDIRab (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 13:30:31 -0400
Received: from mga01.intel.com ([192.55.52.88]:6795 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933783AbaDIRaY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 13:30:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,827,1389772800"; 
   d="scan'208";a="510270005"
From: "Luck, Tony" <tony.luck@intel.com>
To: Aristeu Rozanski <aris@redhat.com>, Borislav Petkov <bp@alien8.de>
CC: Jason Baron <jbaron@akamai.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "dougthompson@xmission.com" <dougthompson@xmission.com>,
        "m.chehab@samsung.com" <m.chehab@samsung.com>,
        "mitake@dcl.info.waseda.ac.jp" <mitake@dcl.info.waseda.ac.jp>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 3/3] ie31200_edac: Add driver
Thread-Topic: [PATCH 3/3] ie31200_edac: Add driver
Thread-Index: AQHPUErabVWTFTq13UyiP3ii3SIN9psJpHwAgAAhKgD//8g+EA==
Date: Wed, 9 Apr 2014 17:17:53 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F31E22EAC@ORSMSX106.amr.corp.intel.com>
References: <cover.1396645124.git.jbaron@akamai.com>
 <760765424abe31811027ff3efd078bc858b7d3ed.1396645124.git.jbaron@akamai.com>
 <20140409113552.GJ6529@pd.tnic> <20140409133433.GJ29214@redhat.com>
In-Reply-To: <20140409133433.GJ29214@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Why not put it into sb_edac - it is small enough and if you're lucky,
>> you might even share functionality?
>
> By quickly looking at the driver (sorry Jason, no proper review yet :( )
> it's a very different beast. Tony, any insights on why?

The E3-12xx processors connect out to a different (desktop) chipset from
the E5 (server parts).  Perhaps that means the memory controller are different
too???

-Tony
