Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754828Ab3LQWej (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 17:34:39 -0500
Received: from mga01.intel.com ([192.55.52.88]:7449 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752003Ab3LQWei convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 17:34:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,503,1384329600"; 
   d="scan'208";a="451647218"
From: "Luck, Tony" <tony.luck@intel.com>
To: Jan Beulich <JBeulich@suse.com>
CC: "Fleming, Matt" <matt.fleming@intel.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] don't select EFI from certain special ACPI drivers
Thread-Topic: [PATCH] don't select EFI from certain special ACPI drivers
Thread-Index: AQHO+my1C4a4zs00z0mDkuPRYrY8UJpXcL+ggAEeFQCAAGxOcA==
Date: Tue, 17 Dec 2013 22:34:32 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F31D8B8CE@ORSMSX106.amr.corp.intel.com>
References: <52AF1EBC020000780010DBF9@nat28.tlf.novell.com>
 <3908561D78D1C84285E8C5FCA982C28F31D8A4C2@ORSMSX106.amr.corp.intel.com>
 <52B013E8020000780010E009@nat28.tlf.novell.com>
In-Reply-To: <52B013E8020000780010E009@nat28.tlf.novell.com>
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

> No, it hasn't. But I explicitly checked the relevant EFI=n and EFI=y
> cases.

Jan,

I pushed your patch into my "next" tree - the robots will notice soon and send
us e-mail if they find any issues.

-Tony

