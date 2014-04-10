Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759295AbaDJXGH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 19:06:07 -0400
Received: from mga03.intel.com ([143.182.124.21]:55480 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753896AbaDJXGF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 19:06:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,837,1389772800"; 
   d="scan'208";a="417548655"
From: "Du, Wenkai" <wenkai.du@intel.com>
To: "Westerberg, Mika" <mika.westerberg@intel.com>
CC: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] i2c-designware: Mask interrupts during i2c controller
 enable
Thread-Topic: [PATCH] i2c-designware: Mask interrupts during i2c controller
 enable
Thread-Index: Ac9QJwrpXJhe4Vv7Q76dkBKVgbE+4AARZeWAAA7Jh9D//5EOAIAATf0QgABzAACAAldQAIAA/RGAgABeqgCAAAfmAIAAXh4QgADlsQD//ghNMIAFBYwA//+LzVA=
Date: Thu, 10 Apr 2014 23:06:01 +0000
Message-ID: <7286EAF50D3F4E4AADE7FEECEBF8B5A547FFA3F1@ORSMSX110.amr.corp.intel.com>
References: <20140404184232.GC19349@intel.com>
 <7286EAF50D3F4E4AADE7FEECEBF8B5A537A71351@ORSMSX109.amr.corp.intel.com>
 <20140405061316.GF19349@intel.com>
 <20140406185818.3aaca03d@alan.etchedpixels.co.uk>
 <20140407090403.GG19349@intel.com>
 <20140407154252.6b8f0f7e@alan.etchedpixels.co.uk>
 <20140407151107.GL19349@intel.com>
 <7286EAF50D3F4E4AADE7FEECEBF8B5A537A72207@ORSMSX109.amr.corp.intel.com>
 <20140408103006.GQ19349@intel.com>
 <7286EAF50D3F4E4AADE7FEECEBF8B5A537A73919@ORSMSX109.amr.corp.intel.com>
 <20140410090826.GW19349@intel.com>
In-Reply-To: <20140410090826.GW19349@intel.com>
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

> -----Original Message-----
> From: Westerberg, Mika
> Sent: Thursday, April 10, 2014 2:08 AM
> To: Du, Wenkai
> Cc: One Thousand Gnomes; linux-i2c@vger.kernel.org; Wolfram Sang; linux-
> kernel@vger.kernel.org
> Subject: Re: [PATCH] i2c-designware: Mask interrupts during i2c controller enable

> Can you resend this patch with a changelog that explains the resume issue?
Updated patch descriptions in new thread: 
[PATCH V2] i2c-designware: Mask all interrupts during i2c controller enable

