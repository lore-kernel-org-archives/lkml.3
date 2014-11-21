Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752094AbaKUVVt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 16:21:49 -0500
Received: from mga09.intel.com ([134.134.136.24]:42645 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750802AbaKUVVr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 16:21:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,432,1413270000"; 
   d="scan'208";a="641403848"
From: "Luck, Tony" <tony.luck@intel.com>
To: Aristeu Rozanski <aris@redhat.com>
CC: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Doug Thompson <dougthompson@xmission.com>,
        Borislav Petkov <bp@alien8.de>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] sb_edac: Add support for Broadwell-DE processor
Thread-Topic: [PATCH] sb_edac: Add support for Broadwell-DE processor
Thread-Index: AQHQBdBTPxha4rX6skaDQTrN5nISI5xrlfHQ
Date: Fri, 21 Nov 2014 21:21:45 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F329503FE@ORSMSX114.amr.corp.intel.com>
References: <546a37ab3156619eb3@agluck-desk.sc.intel.com>
 <20141121211455.GN21208@redhat.com>
In-Reply-To: <20141121211455.GN21208@redhat.com>
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

>> +	{ PCI_DESCR(PCI_DEVICE_ID_INTEL_BROADWELL_IMC_HA0_TAD2, 1)	},
>> +	{ PCI_DESCR(PCI_DEVICE_ID_INTEL_BROADWELL_IMC_HA0_TAD3, 1)	},
>
> You are marking TAD2 and TAD3 as optional here, but
>
>> +	for (i = 0; i < NUM_CHANNELS; i++) {
>> +		if (!pvt->pci_tad[i])
>> +			goto enodev;
>> +	}
>
> It's not optional here.

Heh. Cut & paste from the HASWELL version which has the same issue.
So we need to fix there too.

Thanks for the review.

-Tony
