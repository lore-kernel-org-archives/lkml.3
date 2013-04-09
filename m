Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761152Ab3DINOP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 09:14:15 -0400
Received: from mga14.intel.com ([143.182.124.37]:12540 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759676Ab3DINON convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 09:14:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,439,1363158000"; 
   d="scan'208";a="283664035"
From: "Winkler, Tomas" <tomas.winkler@intel.com>
To: Greg KH <gregkh@linuxfoundation.org>,
        "Samuel Ortiz (sameo@linux.intel.com)" <sameo@linux.intel.com>
CC: "arnd@arndb.de" <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [char-misc-next 0/3 V6] Support NFC Device on MEI CL Bus
Thread-Topic: [char-misc-next 0/3 V6] Support NFC Device on MEI CL Bus
Thread-Index: AQHONLLD744sF7MD70qzazUufiLKxZjM0PmAgAENUZA=
Date: Tue, 9 Apr 2013 13:12:48 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B01EFB6B8@HASMSX106.ger.corp.intel.com>
References: <1365464495-17642-1-git-send-email-tomas.winkler@intel.com>
 <20130409000815.GA30420@kroah.com>
In-Reply-To: <20130409000815.GA30420@kroah.com>
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

> 
> On Tue, Apr 09, 2013 at 02:41:32AM +0300, Tomas Winkler wrote:
> > v5 -> v6
> >  1. include/linux/uapi/mei/nfc.h - provides API also for pure
> >     user space implementation as found under Android.
> >  2. Removed INTEL_MEI_BUS_NFC Kconfig option.
> >     The NFC info client is disconnected as soon as we
> >     get the FW info and the regular client is connected only when
> >     mei_cl_enable_device() is explicitly called from an nfc driver.
> >     The mei cl bus now doesn't connect NFC  exclusively.
> >  3. Added pn544 to the possibly detected NFC chipsets.
> >
> > Depends on:
> > 	mei: bus: Add device enabling and disabling API
> 
> If this is a nfc device, why isn't it using the nfc_register_device() and
> nfc_unregister_device() calls?  Shouldn't you be using the in-kernel nfc api
> we already have?
> 

Adding Samuel.

Thanks
Tomas
