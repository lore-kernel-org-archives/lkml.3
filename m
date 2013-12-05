Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932905Ab3LEQvN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 11:51:13 -0500
Received: from mga02.intel.com ([134.134.136.20]:41527 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756771Ab3LEQvJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 11:51:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,834,1378882800"; 
   d="scan'208";a="419983664"
From: "Winkler, Tomas" <tomas.winkler@intel.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "arnd@arndb.de" <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [char-misc-next] mei: add 9 series PCH mei device ids
Thread-Topic: [char-misc-next] mei: add 9 series PCH mei device ids
Thread-Index: AQHO8Yy248h4QHKjd0O0ju8qZe1sXZpFiNuAgABEcLA=
Date: Thu, 5 Dec 2013 16:50:00 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B1AF24D4C@HASMSX106.ger.corp.intel.com>
References: <1386228884-30978-1-git-send-email-tomas.winkler@intel.com>
 <20131205143153.GA5151@kroah.com>
In-Reply-To: <20131205143153.GA5151@kroah.com>
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



> On Thu, Dec 05, 2013 at 09:34:44AM +0200, Tomas Winkler wrote:
> > And Lynx Point H Refresh and Wildcat Point LP
> > device ids.
> >
> > Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> > ---
> > V2: remove duplicated  LPT entry
> >
> >  drivers/misc/mei/hw-me-regs.h | 5 ++++-
> >  drivers/misc/mei/pci-me.c     | 4 +++-
> >  2 files changed, 7 insertions(+), 2 deletions(-)
> 
> This should go into 3.13-final, right?  What about -stable versions?

Yes, this can go to stable as well. I need to dig bit in from which version this is relevant, I think 3.9 and up
I will resend with info.
Can you just clarify for me what is the policy here, is the support for new HW a stable candidate?
 

Thanks
Tomas
