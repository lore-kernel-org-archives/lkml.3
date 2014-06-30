Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751857AbaF3LXc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 07:23:32 -0400
Received: from mail1.skidata.com ([91.230.2.99]:31552 "EHLO mail1.skidata.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750969AbaF3LXa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 07:23:30 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqEEAGRIsVOsEApK/2dsb2JhbABahDnFVwGBHXWEAwEBBAEnEz8QCw0IDCUPSAYOBYg6DccTF48HB4RDAQSaXYcwkBKCLg
X-IPAS-Result: AqEEAGRIsVOsEApK/2dsb2JhbABahDnFVwGBHXWEAwEBBAEnEz8QCw0IDCUPSAYOBYg6DccTF48HB4RDAQSaXYcwkBKCLg
Date: Mon, 30 Jun 2014 13:23:27 +0200
From: Richard Leitner <richard.leitner@skidata.com>
To: David Laight <David.Laight@ACULAB.COM>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2] usb: gadget: serial: replace hardcoded ttyGS with
 PREFIX
Message-ID: <20140630132327.39b9d4d2@lxbuild.skidata.net>
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6D1726935E@AcuExch.aculab.com>
References: <20140627133721.10ca6cab@lxbuild.skidata.net>
	<20140627174628.GA1449@kroah.com>
	<20140630083205.596557f1@lxbuild.skidata.net>
	<20140630103616.620a13a2@lxbuild.skidata.net>
	<063D6719AE5E284EB5DD2968C1650D6D1726930B@AcuExch.aculab.com>
	<20140630105609.66d4be83@lxbuild.skidata.net>
	<063D6719AE5E284EB5DD2968C1650D6D1726935E@AcuExch.aculab.com>
Organization: SKIDATA AG
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.16.60.30]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 30 Jun 2014 09:08:01 +0000
David Laight <David.Laight@ACULAB.COM> wrote:

> > > From: Of Richard Leitner
> > > > Replaces all hardcoded ttyGS strings with the PREFIX macro.
> > > > Due to the fact the strings are spread over different source files the
> > > > PREFIX definition is moved to u_serial.h
> > >
> > > Lots of changes like:
> > > > -		DBG(cdev, "acm ttyGS%d completion, err %d\n",
> > > > -				acm->port_num, req->status);
> > > > +		DBG(cdev, "acm %s%d completion, err %d\n",
> > > > +				PREFIX, acm->port_num, req->status);
> > >
> > > I'm not sure this improves the code.
> > 
> > Maybe you're right, the readability of the code wouldn't be better afterwards,

but as I already mentioned IMHO if there is such a macro it should be used everywhere or nowhere...
	
> 
> Indeed it will make most attempts to grep for the error message fail.

So your thought is to carve it out completely?

Are there any other opinions/ideas on that?

regards,
richard
