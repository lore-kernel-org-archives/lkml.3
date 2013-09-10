Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752590Ab3IJQhv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 12:37:51 -0400
Received: from mga14.intel.com ([143.182.124.37]:18932 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751207Ab3IJQhu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 12:37:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,879,1371106800"; 
   d="scan'208";a="293132027"
From: "Winkler, Tomas" <tomas.winkler@intel.com>
To: Joe Perches <joe@perches.com>, Adam Jackson <ajax@redhat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] mei: Don't dev_err() on suspend
Thread-Topic: [PATCH] mei: Don't dev_err() on suspend
Thread-Index: AQHOrj4n23RvrCqnAkGmsME+IfYqepm+8KGAgAA6z6A=
Date: Tue, 10 Sep 2013 16:37:44 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B1AEC1D72@HASMSX106.ger.corp.intel.com>
References: <1378828483-11813-1-git-send-email-ajax@redhat.com>
 <1378829187.15812.11.camel@joe-AO722>
In-Reply-To: <1378829187.15812.11.camel@joe-AO722>
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

I

> -----Original Message-----
> From: Joe Perches [mailto:joe@perches.com]
> Sent: Tuesday, September 10, 2013 19:06
> To: Adam Jackson
> Cc: linux-kernel@vger.kernel.org; Winkler, Tomas
> Subject: Re: [PATCH] mei: Don't dev_err() on suspend
> 
> On Tue, 2013-09-10 at 11:54 -0400, Adam Jackson wrote:
> > Suspend isn't an error condition, and I'm sick of seeing this (and only
> > this) on the console when I suspend with quiet boot enabled.
> []
> > diff --git a/drivers/misc/mei/pci-me.c b/drivers/misc/mei/pci-me.c
> []
> > @@ -262,7 +262,7 @@ static int mei_me_pci_suspend(struct device *device)
> >  	if (!dev)
> >  		return -ENODEV;
> >
> > -	dev_err(&pdev->dev, "suspend\n");
> > +	dev_info(&pdev->dev, "suspend\n");
> 
> dev_dbg instead?

Yes, but I believe we fixed that long ago were do you see this?
Thanks
Tomas
 

