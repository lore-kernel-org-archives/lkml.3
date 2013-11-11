Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754315Ab3KKPO4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 10:14:56 -0500
Received: from mga02.intel.com ([134.134.136.20]:30285 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753801Ab3KKPOt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 10:14:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,678,1378882800"; 
   d="scan'208";a="425602340"
From: "Winkler, Tomas" <tomas.winkler@intel.com>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "arnd@arndb.de" <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [char-misc-next 0/3]  mei: driver cleanups
Thread-Topic: [char-misc-next 0/3]  mei: driver cleanups
Thread-Index: AQHO3u6uEZVOvgaKmU6WDA/aN75o3ZogI0Ag
Date: Mon, 11 Nov 2013 15:14:42 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B1AF0929D@HASMSX106.ger.corp.intel.com>
References: <1384169168-30281-1-git-send-email-tomas.winkler@intel.com>
 <5B8DA87D05A7694D9FA63FD143655C1B1AF0913E@HASMSX106.ger.corp.intel.com>
 <20131111150212.GA16112@kroah.com>
In-Reply-To: <20131111150212.GA16112@kroah.com>
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
> From: gregkh@linuxfoundation.org [mailto:gregkh@linuxfoundation.org]
> Sent: Monday, November 11, 2013 17:02
> To: Winkler, Tomas
> Cc: arnd@arndb.de; linux-kernel@vger.kernel.org
> Subject: Re: [char-misc-next 0/3] mei: driver cleanups
> 
> On Mon, Nov 11, 2013 at 11:35:40AM +0000, Winkler, Tomas wrote:
> >
> >
> > >
> > > *** BLURB HERE ***
> > Oops, sorry for that.
> 
> So, any hint for what these are for?  I can't take patches until
> 3.13-rc1 is out, which will be a few weeks.  But then, which should this
> be for, 3.13 as these are regression fixes, or 3.14 as they are only
> "cleanups"?

No regressions here, I don't mind it will be in 3.14
I will mark fixes 3.13 properly (hopefully w/o BLURB)

Tomas

