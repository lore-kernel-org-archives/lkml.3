Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753953Ab3GXUIz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 16:08:55 -0400
Received: from mga03.intel.com ([143.182.124.21]:2066 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752070Ab3GXUIy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 16:08:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,737,1367996400"; 
   d="scan'208";a="370415899"
From: "Winkler, Tomas" <tomas.winkler@intel.com>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
CC: "Shuah Khan (shuah.kh@samsung.com)" <shuah.kh@samsung.com>,
        "'arnd@arndb.de'" <arnd@arndb.de>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'gregkh@linuxfoundation.org'" <gregkh@linuxfoundation.org>
Subject: RE: [char-misc 0/4 3.11] Fix mei suspend/resume failure
Thread-Topic: [char-misc 0/4 3.11] Fix mei suspend/resume failure
Thread-Index: AQHOgudK0Ej0F1tjp0OVOBJnDTbTCplpBFwQgAg8U/CAAtfNgIAANIwg
Date: Wed, 24 Jul 2013 20:08:49 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B1AE73A9C@HASMSX106.ger.corp.intel.com>
References: <1374063197-26855-1-git-send-email-tomas.winkler@intel.com>
 <5B8DA87D05A7694D9FA63FD143655C1B028EBE55@HASMSX106.ger.corp.intel.com>
 <5B8DA87D05A7694D9FA63FD143655C1B1AE65788@HASMSX106.ger.corp.intel.com>
 <51F0321B.4040005@openvz.org>
In-Reply-To: <51F0321B.4040005@openvz.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.184.70.13]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> 
> Winkler, Tomas wrote:
> >>
> >>
> >>>
> >>> This series should fix the long standing reset storm issue in mei
> >>> suspend/resume failure
> >>>
> >
> > Can you guys confirm these fixes the issue for you.
> > Thanks
> > Tomas
> 
> Nope, it's still broken
> 
> kernel: 3.10.2 + my patch for i915 + four your patches. config in attachment
> 

Very surprising,
Can you send me the pci ids of the mei device on your platform. 
Thanks
Tomas
