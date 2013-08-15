Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751793Ab3HOEFc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 00:05:32 -0400
Received: from mga11.intel.com ([192.55.52.93]:27231 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750899Ab3HOEFb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 00:05:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,882,1367996400"; 
   d="scan'208";a="386586493"
From: "Winkler, Tomas" <tomas.winkler@intel.com>
To: Andy Lutomirski <luto@amacapital.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: mei oopses at startup if it's built-in (3.11-rc5)
Thread-Topic: mei oopses at startup if it's built-in (3.11-rc5)
Thread-Index: AQHOmUzhv5Q8y1DI8ECsaHXIzapOWZmVmMTw
Date: Thu, 15 Aug 2013 04:05:26 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B1AE89B41@HASMSX106.ger.corp.intel.com>
References: <CALCETrXmy1KwGUNbG0pgsbAt=mk27P3xd0ja4i9sPB6RhbcOeg@mail.gmail.com>
In-Reply-To: <CALCETrXmy1KwGUNbG0pgsbAt=mk27P3xd0ja4i9sPB6RhbcOeg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.184.70.12]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Andy Lutomirski [mailto:luto@amacapital.net]
> Sent: Thursday, August 15, 2013 03:15
> To: Winkler, Tomas; linux-kernel@vger.kernel.org
> Subject: mei oopses at startup if it's built-in (3.11-rc5)
> 
> It blows up early enough that it's awkward to get the whole oops, but it's in
> the probe function.  If it's a module, I get instead:
> 
> [   73.401679] mei_me 0000:00:16.0: Device doesn't have valid ME Interface
> [   73.401684] mei_me 0000:00:16.0: initialization failed.
> 
> Let me know if I should debug further, but this may be obvious.

I would ask you for pci config space dump


Thanks
Tomas
