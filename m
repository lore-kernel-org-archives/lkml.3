Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757600Ab3GETEM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 15:04:12 -0400
Received: from mxout1.idt.com ([157.165.5.25]:48295 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757523Ab3GETEK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 15:04:10 -0400
From: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
To: Dan Carpenter <dan.carpenter@oracle.com>, Ryan Mallon <rmallon@gmail.com>
CC: Matt Porter <mporter@kernel.crashing.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: RE: [patch] rapidio: use after free in unregister function
Thread-Topic: [patch] rapidio: use after free in unregister function
Thread-Index: AQHOeU4vwIsej/KKHU2Ty5bBmopwsJlWIqEAgABPGZA=
Date: Fri, 5 Jul 2013 19:04:02 +0000
Message-ID: <8D983423E7EDF846BB3056827B8CC5D14BC3AA91@corpmail1.na.ads.idt.com>
References: <20130705060231.GA14443@elgon.mountain>
 <51D67066.9070105@gmail.com> <20130705071912.GY5714@mwanda>
In-Reply-To: <20130705071912.GY5714@mwanda>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.165.140.29]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Dan Carpenter [mailto:dan.carpenter@oracle.com]
> Sent: Friday, July 05, 2013 3:19 AM
> To: Ryan Mallon
> Cc: Matt Porter; Bounine, Alexandre; linux-kernel@vger.kernel.org;
> kernel-janitors@vger.kernel.org
> Subject: Re: [patch] rapidio: use after free in unregister function
> 
> On Fri, Jul 05, 2013 at 05:06:14PM +1000, Ryan Mallon wrote:
> > On 05/07/13 16:02, Dan Carpenter wrote:
> > It looks like an mport_id can only be assigned to one scan entry (see
> > rio_register_scan), so you can use list_for_each_entry and break;
> after
> > the kfree(scan); instead.
> 
> Yeah.  You're right.  I'll resend.
> 
> regards,
> dan carpenter

Thank you for catching it. Missed it because we have only one enumerator so far.

Alex.
