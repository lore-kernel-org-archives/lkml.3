Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752002Ab3LPXE1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 18:04:27 -0500
Received: from mga02.intel.com ([134.134.136.20]:26695 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750935Ab3LPXE0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 18:04:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,498,1384329600"; 
   d="scan'208";a="445306450"
From: "Luck, Tony" <tony.luck@intel.com>
To: Jan Beulich <JBeulich@suse.com>
CC: "Fleming, Matt" <matt.fleming@intel.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] don't select EFI from certain special ACPI drivers
Thread-Topic: [PATCH] don't select EFI from certain special ACPI drivers
Thread-Index: AQHO+my1C4a4zs00z0mDkuPRYrY8UJpXcL+g
Date: Mon, 16 Dec 2013 23:04:24 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F31D8A4C2@ORSMSX106.amr.corp.intel.com>
References: <52AF1EBC020000780010DBF9@nat28.tlf.novell.com>
In-Reply-To: <52AF1EBC020000780010DBF9@nat28.tlf.novell.com>
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

> Adjust Kconfig and build logic so that the bad dependency gets avoided.

Has this been exposed to a randconfig test robot?  Moving cper.c has already
dropped a few e-mails into my mailbox ... I'm now wary about the corner cases.

-Tony
