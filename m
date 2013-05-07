Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932839Ab3EGDxo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 23:53:44 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:40582 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932391Ab3EGDxm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 23:53:42 -0400
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: Tony Lindgren <tony@atomide.com>
CC: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: mach-omap2/timer.c: Bug introduced while merging patch -
 ff931c82
Thread-Topic: mach-omap2/timer.c: Bug introduced while merging patch -
 ff931c82
Thread-Index: Ac5KKDi66bBp82szRKKLkCu0fW3iLwAAuOcAABaw+tD//9OLgP//Mqqg
Date: Tue, 7 May 2013 03:53:13 +0000
Message-ID: <79CD15C6BA57404B839C016229A409A83EC7CB23@DBDE04.ent.ti.com>
References: <79CD15C6BA57404B839C016229A409A83EC7C45D@DBDE04.ent.ti.com>
 <20130506152706.GD28721@atomide.com>
 <79CD15C6BA57404B839C016229A409A83EC7C93A@DBDE04.ent.ti.com>
 <20130506233743.GJ28721@atomide.com>
In-Reply-To: <20130506233743.GJ28721@atomide.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Tony Lindgren [mailto:tony@atomide.com]
> Sent: Tuesday, May 07, 2013 5:08 AM
> To: Hiremath, Vaibhav
> Cc: linux-omap@vger.kernel.org; linux-kernel@vger.kernel.org; linux-
> arm-kernel@lists.infradead.org
> Subject: Re: mach-omap2/timer.c: Bug introduced while merging patch -
> ff931c82
> 
> * Hiremath, Vaibhav <hvaibhav@ti.com> [130506 11:35]:
> >
> > Ohh yeah, I already have a patch for it -
> 
> Thanks, I'll add that into omap-for-v3.10/fixes. I modified
> the comments a bit trying to figure out where it changed, updated
> patch below.
> 

Thanks Tony. 

Thanks,
Vaibhav
