Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189Ab3CJTVk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 15:21:40 -0400
Received: from mga14.intel.com ([143.182.124.37]:58627 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753039Ab3CJTVj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 15:21:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,819,1355126400"; 
   d="scan'208";a="212290813"
From: "Winkler, Tomas" <tomas.winkler@intel.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [char-misc 0/2][3.9] Lynx Point LP Bug Fixes for 3.9
Thread-Topic: [char-misc 0/2][3.9] Lynx Point LP Bug Fixes for 3.9
Thread-Index: AQHOHa0QSYVIeoFahke1T6u5Vxqre5ifS1Zw
Date: Sun, 10 Mar 2013 19:21:35 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B01EEAECC@HASMSX106.ger.corp.intel.com>
References: <1362916568-9650-1-git-send-email-tomas.winkler@intel.com>
 <20130310163430.GB4392@kroah.com>
In-Reply-To: <20130310163430.GB4392@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.184.70.10]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > Hi Greg
> > Please, if possible schedule these patches for 3.9 update.
> > The patches fix the reset/initialization for Lynx Point LP (dev_id:
> > 0x9C3A) devices to be found in the Haswell systems.
> >
> > This not a regression per se but it's a fix for a new device.
> 
> What happens if you have this new device and don't have these fixes?

They fail to initialize as the reset flow doesn't complete,  plainly it won't work. 

Similar patch has to be send for  3.7 and 3.8. It  Just needs to be done differently as there
was large code movement included in  3.9. 

I've assumed at the time that Lynx Point LP behaves same as Lynx Point but I was wrong.

Tomas
Thanks


