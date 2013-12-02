Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752888Ab3LBEDv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Dec 2013 23:03:51 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:19927 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752782Ab3LBEDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Dec 2013 23:03:48 -0500
X-AuditID: cbfee68f-b7f336d00000481b-80-529c06a22212
From: Jingoo Han <jg1.han@samsung.com>
To: "'Guenter Roeck'" <linux@roeck-us.net>, "'Joe Perches'" <joe@perches.com>
Cc: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
        "'Bjorn Helgaas'" <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Andy Whitcroft'" <apw@canonical.com>, linux-serial@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <000601ceebdc$ee148de0$ca3da9a0$%han@samsung.com>
 <20131128040750.GA29917@kroah.com>
 <006001ceebfa$c85a1020$590e3060$%han@samsung.com>
 <1385617213.12210.5.camel@joe-AO722> <20131128055328.GA565@kroah.com>
 <1385619863.12210.14.camel@joe-AO722> <529C026E.2000302@roeck-us.net>
 <000f01ceef11$a14acf00$e3e06d00$%han@samsung.com>
 <529C04C7.9050506@roeck-us.net>
In-reply-to: <529C04C7.9050506@roeck-us.net>
Subject: Re: [PATCH 1/5] serial: 8250_pci: use DEFINE_PCI_DEVICE_TABLE macro
Date: Mon, 02 Dec 2013 13:03:46 +0900
Message-id: <001001ceef13$7fa3ee70$7eebcb50$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7vEmcwdTErvnjMSfKY6qsDu+Y6lwAANRkQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDIsWRmVeSWpSXmKPExsVy+t8zI91FbHOCDBav0beYs34Nm8WHtRoW
	S5oyLJoXr2ezuLzwEqvF7PuPWSwu75rDZnF23nE2izOLe9ktniw8w+TA5TGroZfNY8GmUo8T
	M36zeOyfu4bd48uqa8weO783sHv0bVnF6PF5k1wARxSXTUpqTmZZapG+XQJXxuY5JxgLlipX
	XDi+kbGBsVmmi5GTQ0LARGLz8ndMELaYxIV769m6GLk4hASWMUp83HSdpYuRA6zo1rRKiPh0
	RokJOx6zgTQICfxilPh7XxvEZhNQk/jy5TA7iC0i4Clx5sJ6RpAGZoFNTBJf7nxkh+j+wyTx
	48VNsG5OAR2JnzcegnUIC/hILN4+FewMFgFVicer17GA2LwCthLn7k9ghrAFJX5MvgcWZxbQ
	kli/8zgThC0vsXnNW2aIS9UlHv3VhTjCSGLNnK/MECUiEvtevGOE+HIqh8TS9+oQqwQkvk0+
	BPWkrMSmA8wQJZISB1fcYJnAKDELyeJZSBbPQrJ4FpINCxhZVjGKphYkFxQnpRcZ6xUn5haX
	5qXrJefnbmKExHz/Dsa7B6wPMSYDrZ/ILCWanA9MGXkl8YbGZkYWpiamxkbmlmakCSuJ895/
	mBQkJJCeWJKanZpakFoUX1Sak1p8iJGJg1OqgbHsQ7JCknPgQsN1XU6td/42PX1/8k3RT+7o
	SCaBnunBd8/UV/RkSfm6f/zBtOjIb4af79k0BOUk7R+wKaVvYq8/emiS5011ly6n2VambS6d
	BaL5IfP8j55+9u368lZWfYWpOhMKSpnzBMtDfjeu3Fl95fKSVUc8NAP9Gt+rXDa4rOUV06V7
	QomlOCPRUIu5qDgRAPfwsiQPAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFKsWRmVeSWpSXmKPExsVy+t9jQd1FbHOCDBr+alrMWb+GzeLDWg2L
	JU0ZFs2L17NZXF54idVi9v3HLBaXd81hszg77zibxZnFvewWTxaeYXLg8pjV0MvmsWBTqceJ
	Gb9ZPPbPXcPu8WXVNWaPnd8b2D36tqxi9Pi8SS6AI6qB0SYjNTEltUghNS85PyUzL91WyTs4
	3jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMH6EQlhbLEnFKgUEBicbGSvh2mCaEhbroWMI0R
	ur4hQXA9RgZoIGEdY8bmOScYC5YqV1w4vpGxgbFZpouRg0NCwETi1rTKLkZOIFNM4sK99Wxd
	jFwcQgLTGSUm7HjMBpIQEvjFKPH3vjaIzSagJvHly2F2EFtEwFPizIX1jCANzAKbmCS+3PnI
	DtH9h0nix4ubYN2cAjoSP288BOsQFvCRWLx9KhOIzSKgKvF49ToWEJtXwFbi3P0JzBC2oMSP
	yffA4swCWhLrdx5ngrDlJTavecsMcbW6xKO/uhBHGEmsmfOVGaJERGLfi3eMExiFZiGZNAvJ
	pFlIJs1C0rKAkWUVo2hqQXJBcVJ6rpFecWJucWleul5yfu4mRnBKeSa9g3FVg8UhRgEORiUe
	3gsnZgcJsSaWFVfmHmKU4GBWEuFl+QsU4k1JrKxKLcqPLyrNSS0+xJgM9OhEZinR5Hxgussr
	iTc0NjEzsjQyszAyMTcnTVhJnPdgq3WgkEB6YklqdmpqQWoRzBYmDk4pYJS2Kp6//zhnasSO
	Vq1KrePFq+ZVWksvnNA494JU1O+82AQJjenSd4/y9l37lftGqy4sqi6WZ6p3HMtW1e3lviEt
	KmE3WZZlfba/ZxFSLLT71stGoZnv101Vm3NWd1b7416OvfFnU3etNyiN4dnCMe2/w28+f82E
	GTZT9mSZ8Mj2tHHU7d/5S4mlOCPRUIu5qDgRAKDQa/VtAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, December 02, 2013 12:56 PM, Guenter Roeck wrote:
> On 12/01/2013 07:50 PM, Jingoo Han wrote:
> > On Monday, December 02, 2013 12:46 PM, Guenter Roeck wrote:
> >> On 12/01/2013 04:07 PM, Jingoo Han wrote:
> >>> On Friday, November 29, 2013 10:34 AM, Jingoo Han wrote:
> >>>> On Thursday, November 28, 2013 3:24 PM, Joe Perches wrote:
> >>>>> On Wed, 2013-11-27 at 21:53 -0800, 'Greg Kroah-Hartman' wrote:
> >>>>>> On Wed, Nov 27, 2013 at 09:40:13PM -0800, Joe Perches wrote:
> >>>>>>> On Thu, 2013-11-28 at 14:29 +0900, Jingoo Han wrote:
> >>>>>>>> On Thursday, November 28, 2013 1:08 PM, Greg Kroah-Hartman wrote:
> >>>>>>>>> On Thu, Nov 28, 2013 at 10:55:35AM +0900, Jingoo Han wrote:
> >>>>>>>>>> This macro is used to create a struct pci_device_id array.
> >>>>>>>>>
> >>>>>>>>> Yeah, and it's a horrid macro that deserves to be removed, please don't
> >>>>>>>>> use it in more places.
> >>>>>>>>>
> >>>>>>>>> Actually, if you could just remove it, that would be best, sorry, I'm
> >>>>>>>>> not going to take these patches.
> >>>>>>>>
> >>>>>>>> (+cc Joe Perches, Andrew Morton, Andy Whitcroft)
> >>>>>>>>
> >>>>>>>> Hi Joe Perches,
> >>>>>>>>
> >>>>>>>> Would you fix checkpatch.pl about DEFINE_PCI_DEVICE_TABLE?
> >>>>>>>> Currently, checkpatch.pl guides to use DEFINE_PCI_DEVICE_TABLE
> >>>>>>>> as below.
> >>>>>>>>
> >>>>>>>>     WARNING: Use DEFINE_PCI_DEVICE_TABLE for struct pci_device_id
> >>>>>>>>     #331: FILE: drivers/usb/host/ehci-pci.c:331:
> >>>>>>>>     +static const struct pci_device_id pci_ids [] = { {
> >>>>>>>>
> >>>>>>>> However, Greg Kroah-Hartman mentioned that DEFINE_PCI_DEVICE_TABLE
> >>>>>>>> shouldn't be used anymore.
> >>>>>>>>
> >>>>>>>> So, would you change checkpatch.pl in order to guide to use
> >>>>>>>> struct pci_device_id instead of DEFINE_PCI_DEVICE_TABLE?
> >>>>>>>>
> >>>>>>>> For example,
> >>>>>>>>     WARNING: Use struct pci_device_id instead of DEFINE_PCI_DEVICE_TABLE
> >>>>>>>
> >>>>>>> The documentation doesn't agree with Greg.
> >>>>> []
> >>>>>> I say just remove it, I should have done that years ago when I was the
> >>>>>> PCI maintainer, just never got around to it.  No other bus has something
> >>>>>> like this for their device ids, why should PCI be "special"?
> >>>>>
> >>>>> Anyone else have an opinion?
> >>>>>
> >>>>> I don't care one way or another, but please, one way
> >>>>> not two.
> >>>>
> >>
> >> Same here.
> >>
> >>>> (+cc Bjorn Helgaas, linux-pci)
> >>>>
> >>>> Then, how about the following steps?
> >>>>
> >>>> 1. Fix ./Documentation/PCI/pci.txt as below.
> >>>>      (Jingoo Han)
> >>>>      The ID table is an array of struct pci_device_id entries ending with an
> >>>>      -all-zero entry; use of the macro DEFINE_PCI_DEVICE_TABLE is the preferred
> >>>>      -method of declaring the table.  Each entry consists of:
> >>>>      +all-zero entry; Each entry consists of:
> >>>>
> >>>> 2. Fix ./scripts/checkpatch.pl in order to guide to use
> >>>>       struct pci_device_id instead of DEFINE_PCI_DEVICE_TABLE.
> >>>>       (Joe Perches)
> >>>
> >>> If all DEFINE_PCI_DEVICE_TABLEs are replaced with 'const struct pci_device_id'
> >>> and these patches are merged through 'driver-core.git', it will be not
> >>> necessary to fix ./scripts/checkpatch.pl.
> >>>
> >> Why not ?
> >
> > I will replace all DEFINE_PCI_DEVICE_TABLEs with 'const struct pci_device_id',
> > and remove the definition of DEFINE_PCI_DEVICE_TABLE macro.
> >
> > --- a/include/linux/pci.h
> > +++ b/include/linux/pci.h
> > @@ -631,16 +631,6 @@ struct pci_driver {
> >   #define        to_pci_driver(drv) container_of(drv, struct pci_driver, driver)
> >
> >   /**
> > - * DEFINE_PCI_DEVICE_TABLE - macro used to describe a pci device table
> > - * @_table: device table name
> > - *
> > - * This macro is used to create a struct pci_device_id array (a device table)
> > - * in a generic manner.
> > - */
> > -#define DEFINE_PCI_DEVICE_TABLE(_table) \
> > -       const struct pci_device_id _table[]
> > -
> > -/**
> >
> > In this case, there is no DEFINE_PCI_DEVICE_TABLE usage
> > in the kernel. If someone uses DEFINE_PCI_DEVICE_TABLE macro,
> > it will make  build error.
> >
> 
> And that will make the checkpatch warning go away ?
> That seems to be very unlikely.

OK, I will ask Joe Perches to remove the following checkpatch
warning.

    WARNING: Use DEFINE_PCI_DEVICE_TABLE for struct pci_device_id

Best regards,
Jingoo Han

