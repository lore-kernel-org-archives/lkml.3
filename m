Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755160AbaHUNOW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 09:14:22 -0400
Received: from mga11.intel.com ([192.55.52.93]:3630 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752817AbaHUNOU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 09:14:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="375268074"
From: "Winkler, Tomas" <tomas.winkler@intel.com>
To: Josh Boyer <jwboyer@fedoraproject.org>
CC: Greg KH <gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@arndb.de>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: RE: [char-misc-next 03/14] mei: me_client lookup function to return
 me_client object
Thread-Topic: [char-misc-next 03/14] mei: me_client lookup function to
 return me_client object
Thread-Index: AQHPvTwL7gbUsgV51kiPCMZT1lrcQJvbCL9g
Date: Thu, 21 Aug 2014 13:14:15 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B1C3A5270@HASMSX106.ger.corp.intel.com>
References: <1408620563-25834-1-git-send-email-tomas.winkler@intel.com>
	<1408620563-25834-3-git-send-email-tomas.winkler@intel.com>
 <CA+5PVA71dg5-2Vb=YaxAfon3Qo1m4uivqmsRQbN0x+OztrX=9Q@mail.gmail.com>
In-Reply-To: <CA+5PVA71dg5-2Vb=YaxAfon3Qo1m4uivqmsRQbN0x+OztrX=9Q@mail.gmail.com>
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
> From: jwboyer@gmail.com [mailto:jwboyer@gmail.com] On Behalf Of Josh Boyer
> Sent: Thursday, August 21, 2014 15:33
> To: Winkler, Tomas
> Cc: Greg KH; Arnd Bergmann; Linux-Kernel@Vger. Kernel. Org
> Subject: Re: [char-misc-next 03/14] mei: me_client lookup function to return
> me_client object
> 
> On Thu, Aug 21, 2014 at 7:29 AM, Tomas Winkler <tomas.winkler@intel.com>
> wrote:
> > In order to support dynamic addition/removal of me clients we cannot
> 
> cannot what?
> 
> > It is incontinent to use static array and we can use list.
> > As the first step we change the lookup function to return
> > me client address instead of the index.
> 
> This changelog seems to have some missing parts to it.

Oops , let me see what went wrong here.... 
Thanks
Tomas
 

