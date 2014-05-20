Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752109AbaETIxI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 04:53:08 -0400
Received: from mx0.aculab.com ([213.249.233.131]:50279 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750808AbaETIxG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 04:53:06 -0400
From: David Laight <David.Laight@ACULAB.COM>
To: "'Alan Stern'" <stern@rowland.harvard.edu>,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
CC: Felipe Balbi <balbi@ti.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>,
        "joe@perches.com" <joe@perches.com>,
        "auttamchandani@logicube.com" <auttamchandani@logicube.com>
Subject: RE: [PATCH 3/5] usb: gadget: net2280: Pass checkpacth.pl test
Thread-Topic: [PATCH 3/5] usb: gadget: net2280: Pass checkpacth.pl test
Thread-Index: AQHPc5o4Gni3xBSnKUeJZg5GpS568JtJKX8Q
Date: Tue, 20 May 2014 08:52:33 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D17249DE6@AcuExch.aculab.com>
References: <1400526693-29776-4-git-send-email-ricardo.ribalda@gmail.com>
 <Pine.LNX.4.44L0.1405191531010.1538-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1405191531010.1538-100000@iolanthe.rowland.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.99.200]
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Stern
...
> > -static struct usb_request *
> > -net2280_alloc_request (struct usb_ep *_ep, gfp_t gfp_flags)
> > +static struct usb_request *net2280_alloc_request(struct usb_ep *_ep,
> > +							gfp_t gfp_flags)
> 
> What's with the extreme indentation on the continuation line?  The
> style used here is for continuation lines to be indented by two stops
> relative to the first line.

Also why move the line break?
The Linux kernel has both styles, and the original one (with the
function name starting in column 1) makes it much easier to search
to the definition.

	David



