Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945943Ab3BGXHU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 18:07:20 -0500
Received: from mga14.intel.com ([143.182.124.37]:42217 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753237Ab3BGXHT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 18:07:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,625,1355126400"; 
   d="scan'208";a="254015008"
From: "Winkler, Tomas" <tomas.winkler@intel.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [char-misc-next 01/11] mei: bus: Initial MEI bus type
 implementation
Thread-Topic: [char-misc-next 01/11] mei: bus: Initial MEI bus type
 implementation
Thread-Index: AQHOBYQ3IS4Eu09ZfUys2lPY8fCUR5hu4PkAgAAi8zA=
Date: Thu, 7 Feb 2013 23:07:14 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B01EC3BFE@HASMSX106.ger.corp.intel.com>
References: <1360270997-7639-1-git-send-email-tomas.winkler@intel.com>
 <1360270997-7639-2-git-send-email-tomas.winkler@intel.com>
 <201302072241.07171.arnd@arndb.de> <20130207225922.GH5072@sortiz-mobl>
In-Reply-To: <20130207225922.GH5072@sortiz-mobl>
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



> -----Original Message-----
> From: Samuel Ortiz [mailto:sameo@linux.intel.com]
> Sent: Friday, February 08, 2013 00:59
> To: Arnd Bergmann
> Cc: Winkler, Tomas; gregkh@linuxfoundation.org; linux-
> kernel@vger.kernel.org
> Subject: Re: [char-misc-next 01/11] mei: bus: Initial MEI bus type
> implementation
> 
> On Thu, Feb 07, 2013 at 10:41:06PM +0000, Arnd Bergmann wrote:
> > On Thursday 07 February 2013, Tomas Winkler wrote:
> > > +}
> > > +EXPORT_SYMBOL(mei_add_device);
> > > +
> > > +void mei_remove_device(struct mei_bus_client *client) {
> > > +       device_unregister(&client->dev); }
> > > +EXPORT_SYMBOL(mei_remove_device);
> >
> > One more point: did you intentionally pick EXPORT_SYMBOL over
> > EXPORT_SYMBOL_GPL here?
> No, I didn't.
> 
> > It is your decision as the copyright
> > holder, but the default is often EXPORT_SYMBOL_GPL these days, to make
> > it clear that you don't expect closed source drivers to plug in there.
> I'll fix that if Tomas is ok with it.

So far I'm happy with not forcing GPL,  but I will check that issue.

Thanks
Tomas


