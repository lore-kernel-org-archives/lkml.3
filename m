Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932157AbaF3JJE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 05:09:04 -0400
Received: from mx0.aculab.com ([213.249.233.131]:51612 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932102AbaF3JJB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 05:09:01 -0400
From: David Laight <David.Laight@ACULAB.COM>
To: "'Richard Leitner'" <richard.leitner@skidata.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCHv2] usb: gadget: serial: replace hardcoded ttyGS with
 PREFIX
Thread-Topic: [PATCHv2] usb: gadget: serial: replace hardcoded ttyGS with
 PREFIX
Thread-Index: AQHPlD5SSygGtgUtdESncUl0Nvmcr5uJVOuQ///0GYCAABPTwA==
Date: Mon, 30 Jun 2014 09:08:01 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D1726935E@AcuExch.aculab.com>
References: <20140627133721.10ca6cab@lxbuild.skidata.net>
	<20140627174628.GA1449@kroah.com>
	<20140630083205.596557f1@lxbuild.skidata.net>
	<20140630103616.620a13a2@lxbuild.skidata.net>
	<063D6719AE5E284EB5DD2968C1650D6D1726930B@AcuExch.aculab.com>
 <20140630105609.66d4be83@lxbuild.skidata.net>
In-Reply-To: <20140630105609.66d4be83@lxbuild.skidata.net>
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

From: Richard Leitner 
> On Mon, 30 Jun 2014 08:41:18 +0000
> David Laight <David.Laight@ACULAB.COM> wrote:
> 
> > From: Of Richard Leitner
> > > Replaces all hardcoded ttyGS strings with the PREFIX macro.
> > > Due to the fact the strings are spread over different source files the
> > > PREFIX definition is moved to u_serial.h
> >
> > Lots of changes like:
> > > -		DBG(cdev, "acm ttyGS%d completion, err %d\n",
> > > -				acm->port_num, req->status);
> > > +		DBG(cdev, "acm %s%d completion, err %d\n",
> > > +				PREFIX, acm->port_num, req->status);
> >
> > I'm not sure this improves the code.
> 
> Maybe you're right, the readability of the code wouldn't be better afterwards,
...

Indeed it will make most attempts to grep for the error message fail.

	David



