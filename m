Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752157Ab3LEHeK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 02:34:10 -0500
Received: from mga14.intel.com ([143.182.124.37]:38716 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751779Ab3LEHeI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 02:34:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,831,1378882800"; 
   d="scan'208";a="438930993"
From: "Winkler, Tomas" <tomas.winkler@intel.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "arnd@arndb.de" <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [char-misc-next] mei: add 9 series PCH mei device ids
Thread-Topic: [char-misc-next] mei: add 9 series PCH mei device ids
Thread-Index: AQHO8XEKSg/ku3ZvTky/fxOhHc7lHZpFNLdg
Date: Thu, 5 Dec 2013 07:34:04 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B1AF2461B@HASMSX106.ger.corp.intel.com>
References: <1386068489-19511-1-git-send-email-tomas.winkler@intel.com>
 <20131205041913.GA4975@kroah.com>
In-Reply-To: <20131205041913.GA4975@kroah.com>
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

> >
> > diff --git a/drivers/misc/mei/hw-me-regs.h b/drivers/misc/mei/hw-me-regs.h
> > index 6c0fde5..f83bc80 100644
> > --- a/drivers/misc/mei/hw-me-regs.h
> > +++ b/drivers/misc/mei/hw-me-regs.h
> > @@ -110,8 +110,12 @@
> >  #define MEI_DEV_ID_PPT_3      0x1DBA  /* Panther Point */
> >
> >  #define MEI_DEV_ID_LPT        0x8C3A  /* Lynx Point */
> > +#define MEI_DEV_ID_LPT_H      0x8C3A  /* Lynx Point H */
> 
> Why duplicate this #define?

> And, now that you changed it, why keep the "old" one around, it's no
> longer used anywhere else?
> 
The correct name is LPT_H so  I've just missed to remove the line, sending V2.

Thanks
Tomas
