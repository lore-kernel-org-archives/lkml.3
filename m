Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751991AbaLRWqm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 17:46:42 -0500
Received: from mga09.intel.com ([134.134.136.24]:26402 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751637AbaLRWql convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 17:46:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="501208681"
From: "Winkler, Tomas" <tomas.winkler@intel.com>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "arnd@arndb.de" <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [char-misc-next 1/3 V2] mei: add ABI documentation for
 fw_status exported through sysfs
Thread-Topic: [char-misc-next 1/3 V2] mei: add ABI documentation for
 fw_status exported through sysfs
Thread-Index: AQHQCjsERLi9osFcq0OziaUBHOD0bpyVNePQgAC0RQCAACmg4A==
Date: Thu, 18 Dec 2014 22:46:37 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B2CCEF909@HASMSX106.ger.corp.intel.com>
References: <1417090049-23219-1-git-send-email-tomas.winkler@intel.com>
 <5B8DA87D05A7694D9FA63FD143655C1B2CCED19D@HASMSX106.ger.corp.intel.com>
 <20141218221504.GC10229@kroah.com>
In-Reply-To: <20141218221504.GC10229@kroah.com>
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
> From: gregkh@linuxfoundation.org [mailto:gregkh@linuxfoundation.org]
> Sent: Friday, December 19, 2014 00:15
> To: Winkler, Tomas
> Cc: arnd@arndb.de; linux-kernel@vger.kernel.org
> Subject: Re: [char-misc-next 1/3 V2] mei: add ABI documentation for fw_status
> exported through sysfs
> 
> On Thu, Dec 18, 2014 at 09:37:12AM +0000, Winkler, Tomas wrote:
> >
> >
> > >
> > > Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> > > ---
> > > V2: rephrase the description
> > >  Documentation/ABI/testing/sysfs-class-mei | 15 +++++++++++++++
> > >  1 file changed, 15 insertions(+)
> > >
> > Greg you've  included 'mei: export fw status registers through sysfs' to 3.19-rc1
> pull request
> > but left this documentation patch out.
> 
> I don't remember what happened there, can you resend and I will queue it
> up for after 3.19-rc1?


Thanks
Done

