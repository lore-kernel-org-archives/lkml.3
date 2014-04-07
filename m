Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755361AbaDGNNL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 09:13:11 -0400
Received: from mga01.intel.com ([192.55.52.88]:50009 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755217AbaDGNNJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 09:13:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,810,1389772800"; 
   d="scan'208";a="508409946"
From: "Winkler, Tomas" <tomas.winkler@intel.com>
To: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
CC: "Greg KH (gregkh@linuxfoundation.org)" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: 3.0 -> 3.10 regression? poweroff instead of reboot?
Thread-Topic: 3.0 -> 3.10 regression? poweroff instead of reboot?
Thread-Index: AQHPS0iuvgiDnehMNEeghRTCX5Z79Jr4hhDwgAJi2QCAADLdEIADEokAgAA5rQD//9ENgIAH8M5Q
Date: Mon, 7 Apr 2014 13:10:40 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B1AFB7151@HASMSX106.ger.corp.intel.com>
References: <20140310145530.GA27230@pcnci.linuxbox.cz>
 <20140329121550.GA5878@nik-comp.linuxbox.cz>
 <5B8DA87D05A7694D9FA63FD143655C1B1AFAD3D0@HASMSX106.ger.corp.intel.com>
 <20140331120102.GY3339@pcnci.linuxbox.cz>
 <5B8DA87D05A7694D9FA63FD143655C1B1AFAE58E@HASMSX106.ger.corp.intel.com>
 <20140402135812.GI3339@pcnci.linuxbox.cz>
 <5B8DA87D05A7694D9FA63FD143655C1B1AFB112D@HASMSX106.ger.corp.intel.com>
 <20140402143635.GA4410@nik-comp.linuxbox.cz>
In-Reply-To: <20140402143635.GA4410@nik-comp.linuxbox.cz>
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
> Hello Tomas,
> > I would need the devices ids of the MEI device on your platform (lspci  will do
> the job), is this same platform as you tested before?
> > You should not get to requesting the HW readiness w/ my patch.
> 
> yes, it's the same box.
> 
> here are the IDs:
> 
> 00:16.0 Communication controller: Intel Corporation 6 Series/C200 Series
> Chipset Family MEI Controller #1 (rev 04)
> 00:16.1 Communication controller: Intel Corporation 6 Series/C200 Series
> Chipset Family MEI Controller #2 (rev 04)
> 
> 00:16.0 0780: 8086:1c3a (rev 04)
> 00:16.1 0780: 8086:1c3b (rev 04)

Are use you have the patch applied, because the driver just should not load. 
If any case  you dump the firmware status registers"
At offset 0x40 and 0x48 in PCI config space 
sudo hexdump -s 0x48 -n 4 /proc/bus/pci/00/16.0
sudo hexdump -s 0x40 -n 4 /proc/bus/pci/00/16.0

Thanks
Tomas

