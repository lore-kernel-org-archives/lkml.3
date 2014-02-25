Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751705AbaBYJKn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 04:10:43 -0500
Received: from mx0.aculab.com ([213.249.233.131]:45879 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750708AbaBYJKj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 04:10:39 -0500
From: David Laight <David.Laight@ACULAB.COM>
To: "'Joe Perches'" <joe@perches.com>
CC: Thomas Winischhofer <thomas@winischhofer.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: RE: sisusb: Use static const, fix typo
Thread-Topic: sisusb: Use static const, fix typo
Thread-Index: AQHPL3HCyEctK09QYUO12nIH2aQdjprENdvAgACAFACAAPzP8A==
Date: Tue, 25 Feb 2014 09:09:38 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D0F6CA653@AcuExch.aculab.com>
References: <1393034412.3627.11.camel@joe-AO722>
	 <063D6719AE5E284EB5DD2968C1650D6D0F6C9771@AcuExch.aculab.com>
 <1393264876.11020.38.camel@joe-AO722>
In-Reply-To: <1393264876.11020.38.camel@joe-AO722>
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

From: Joe Perches [ 
> On Mon, 2014-02-24 at 10:26 +0000, David Laight wrote:
> > From: Joe Perches
> > > Reduce text a bit by using static const.
> >
> > If you want to save a few bytes remove the pointers.
> > (and the fixed RAM text to get below 7 chars).
> 
> Hi David.
> 
> > eg:
> >
> > > -	const char *ramtypetext2[] = {	"SDR SDRAM", "SDR SGRAM",
> > > -					"DDR SDRAM", "DDR SGRAM" };
> 
> The idea was use static to avoid the array reload
> on each function entry.
> 
> > 	static const char ramtypetext2[8][] = {
> > 		"SDR SD", "SDR SG", "DDR SD", "DDR SG"
> 
> 8 is an odd number here.

Brain fade - not enough coffee.
I meant 'char ramtypetext2[][8]' so that you avoid the pointers as well.

	David



