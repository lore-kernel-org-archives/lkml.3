Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933375Ab3GVVgE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 17:36:04 -0400
Received: from mga14.intel.com ([143.182.124.37]:41753 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932388Ab3GVVgC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 17:36:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,721,1367996400"; 
   d="scan'208";a="335214105"
From: "Winkler, Tomas" <tomas.winkler@intel.com>
To: "Shuah Khan (shuah.kh@samsung.com)" <shuah.kh@samsung.com>,
        "Konstantin Khlebnikov (khlebnikov@openvz.org)" 
	<khlebnikov@openvz.org>
CC: "'arnd@arndb.de'" <arnd@arndb.de>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'gregkh@linuxfoundation.org'" <gregkh@linuxfoundation.org>
Subject: RE: [char-misc 0/4 3.11] Fix mei suspend/resume failure
Thread-Topic: [char-misc 0/4 3.11] Fix mei suspend/resume failure
Thread-Index: AQHOgudK0Ej0F1tjp0OVOBJnDTbTCplpBFwQgAg8U/A=
Date: Mon, 22 Jul 2013 21:35:40 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B1AE65788@HASMSX106.ger.corp.intel.com>
References: <1374063197-26855-1-git-send-email-tomas.winkler@intel.com>
 <5B8DA87D05A7694D9FA63FD143655C1B028EBE55@HASMSX106.ger.corp.intel.com>
In-Reply-To: <5B8DA87D05A7694D9FA63FD143655C1B028EBE55@HASMSX106.ger.corp.intel.com>
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
> 
> >
> > This series should fix the long standing reset storm issue in mei
> > suspend/resume failure
> >

Can you guys confirm these fixes the issue for you.
Thanks
Tomas

> > The issue was reported in few places:
> > https://lkml.org/lkml/2013/6/26/693
> > https://lkml.org/lkml/2013/7/14/69
> >
> >
> > Tomas Winkler (4):
> >   mei: hbm: fix typo in error message
> >   mei: me: fix reset state machine
> >   mei: don't have to clean the state on power up
> >   mei: me: fix waiting for hw ready
> >
> >  drivers/misc/mei/hbm.c   |  2 +-
> >  drivers/misc/mei/hw-me.c | 14 ++++++++++----  drivers/misc/mei/init.c
> > |  3
> > ++-
> >  3 files changed, 13 insertions(+), 6 deletions(-)
> 
> 
> CC: Konstantin and Shuah
> 
> Tomas
