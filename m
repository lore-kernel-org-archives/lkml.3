Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857Ab3LBDud (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Dec 2013 22:50:33 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:19069 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439Ab3LBDu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Dec 2013 22:50:26 -0500
X-AuditID: cbfee691-b7f666d0000048b0-9a-529c0380c879
From: Jingoo Han <jg1.han@samsung.com>
To: "'Guenter Roeck'" <linux@roeck-us.net>
Cc: "'Joe Perches'" <joe@perches.com>,
        "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
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
In-reply-to: <529C026E.2000302@roeck-us.net>
Subject: Re: [PATCH 1/5] serial: 8250_pci: use DEFINE_PCI_DEVICE_TABLE macro
Date: Mon, 02 Dec 2013 12:50:23 +0900
Message-id: <000f01ceef11$a14acf00$e3e06d00$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7vEQD3WiWTzeKQS+6WqizYCeEPBgAABVDw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPIsWRmVeSWpSXmKPExsVy+t8zY90G5jlBBttP8lnMWb+GzeLDWg2L
	JU0ZFs2L17NZXF54idVi9v3HLBaXd81hszg77zibxZnFvewWTxaeYXLg8pjV0MvmsWBTqceJ
	Gb9ZPPbPXcPu8WXVNWaPnd8b2D36tqxi9Pi8SS6AI4rLJiU1J7MstUjfLoErY8/ZRywFp+Qq
	Fn/fwdjAuFGii5GTQ0LAROL6s8UsELaYxIV769m6GLk4hASWMUp8+7WHCabo0bvHzBCJ6YwS
	yxdsZIdwfjFK/Hw7EaydTUBN4suXw+wgtoiAhsT1KXMYQYqYBa4ySez+8xRmLpPE3VWzwTo4
	BXQkZrzbwgpiCwv4SCzePhVsH4uAqsTBM/eYQWxeAVuJs6sOM0HYghI/Jt8D62UW0JJYv/M4
	E4QtL7F5zVugeg6gW9UlHv3VhTjCSOJB6202iBIRiX0v3oEdJCEwk0Ni8dalbBC7BCS+TT7E
	AtErK7HpADPEy5ISB1fcYJnAKDELyeZZSDbPQrJ5FpIVCxhZVjGKphYkFxQnpReZ6hUn5haX
	5qXrJefnbmKERP7EHYz3D1gfYkwGWj+RWUo0OR+YOPJK4g2NzYwsTE1MjY3MLc1IE1YS501/
	lBQkJJCeWJKanZpakFoUX1Sak1p8iJGJg1OqgXFx9+cZO6Qieh7xv9+723DTyXvLJ16NXPjs
	ulScZp7lu6QXX7+wPb1YFm7+QtlFhmHfvasO1ltz7VbMFpv+TfTjwhdfeRL7l+Z87DwcI9+5
	yC1ARGjm5cxr4lrrRV4Kqiz7E94Yt2WyRe7CzH0PzYLPVZYxnJHZtmPyBtGQ/y9Vpk55uebb
	DY/LSizFGYmGWsxFxYkAb+8+7BIDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDKsWRmVeSWpSXmKPExsVy+t9jQd0G5jlBBlebOC3mrF/DZvFhrYbF
	kqYMi+bF69ksLi+8xGox+/5jFovLu+awWZydd5zN4sziXnaLJwvPMDlwecxq6GXzWLCp1OPE
	jN8sHvvnrmH3+LLqGrPHzu8N7B59W1YxenzeJBfAEdXAaJORmpiSWqSQmpecn5KZl26r5B0c
	7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDdKKSQlliTilQKCCxuFhJ3w7ThNAQN10LmMYI
	Xd+QILgeIwM0kLCOMWPP2UcsBafkKhZ/38HYwLhRoouRk0NCwETi0bvHzBC2mMSFe+vZuhi5
	OIQEpjNKLF+wkR3C+cUo8fPtRBaQKjYBNYkvXw6zg9giAhoS16fMYQQpYha4yiSx+89TqPZl
	TBJ3V80G6+AU0JGY8W4LK4gtLOAjsXj7VCYQm0VAVeLgmXtgu3kFbCXOrjrMBGELSvyYfA+s
	l1lAS2L9zuNMELa8xOY1b4HqOYBuVZd49FcX4ggjiQett9kgSkQk9r14xziBUWgWkkmzkEya
	hWTSLCQtCxhZVjGKphYkFxQnpeca6RUn5haX5qXrJefnbmIEp5Vn0jsYVzVYHGIU4GBU4uG9
	cGJ2kBBrYllxZe4hRgkOZiURXpa/QCHelMTKqtSi/Pii0pzU4kOMyUCPTmSWEk3OB6a8vJJ4
	Q2MTMyNLIzMLIxNzc9KElcR5D7ZaBwoJpCeWpGanphakFsFsYeLglGpg9Jy7VEo/XWWO2bed
	Qstf7eo4tzqs5WaC2lzTpQ+ty40N5Y6o9YpfUaqZbc9y4kSTxpE3yTvfvgw/97K50/uUXXTb
	S6MnHxYv2Hagy+7Mwm87/V4+0rs0LfLUwjfn9sasPnTDbcMv+ZWBE+MOdy87p2woEl6+f9mH
	kGsXw428fI+W3lni/2n9x4NKLMUZiYZazEXFiQAg/spabwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, December 02, 2013 12:46 PM, Guenter Roeck wrote:
> On 12/01/2013 04:07 PM, Jingoo Han wrote:
> > On Friday, November 29, 2013 10:34 AM, Jingoo Han wrote:
> >> On Thursday, November 28, 2013 3:24 PM, Joe Perches wrote:
> >>> On Wed, 2013-11-27 at 21:53 -0800, 'Greg Kroah-Hartman' wrote:
> >>>> On Wed, Nov 27, 2013 at 09:40:13PM -0800, Joe Perches wrote:
> >>>>> On Thu, 2013-11-28 at 14:29 +0900, Jingoo Han wrote:
> >>>>>> On Thursday, November 28, 2013 1:08 PM, Greg Kroah-Hartman wrote:
> >>>>>>> On Thu, Nov 28, 2013 at 10:55:35AM +0900, Jingoo Han wrote:
> >>>>>>>> This macro is used to create a struct pci_device_id array.
> >>>>>>>
> >>>>>>> Yeah, and it's a horrid macro that deserves to be removed, please don't
> >>>>>>> use it in more places.
> >>>>>>>
> >>>>>>> Actually, if you could just remove it, that would be best, sorry, I'm
> >>>>>>> not going to take these patches.
> >>>>>>
> >>>>>> (+cc Joe Perches, Andrew Morton, Andy Whitcroft)
> >>>>>>
> >>>>>> Hi Joe Perches,
> >>>>>>
> >>>>>> Would you fix checkpatch.pl about DEFINE_PCI_DEVICE_TABLE?
> >>>>>> Currently, checkpatch.pl guides to use DEFINE_PCI_DEVICE_TABLE
> >>>>>> as below.
> >>>>>>
> >>>>>>    WARNING: Use DEFINE_PCI_DEVICE_TABLE for struct pci_device_id
> >>>>>>    #331: FILE: drivers/usb/host/ehci-pci.c:331:
> >>>>>>    +static const struct pci_device_id pci_ids [] = { {
> >>>>>>
> >>>>>> However, Greg Kroah-Hartman mentioned that DEFINE_PCI_DEVICE_TABLE
> >>>>>> shouldn't be used anymore.
> >>>>>>
> >>>>>> So, would you change checkpatch.pl in order to guide to use
> >>>>>> struct pci_device_id instead of DEFINE_PCI_DEVICE_TABLE?
> >>>>>>
> >>>>>> For example,
> >>>>>>    WARNING: Use struct pci_device_id instead of DEFINE_PCI_DEVICE_TABLE
> >>>>>
> >>>>> The documentation doesn't agree with Greg.
> >>> []
> >>>> I say just remove it, I should have done that years ago when I was the
> >>>> PCI maintainer, just never got around to it.  No other bus has something
> >>>> like this for their device ids, why should PCI be "special"?
> >>>
> >>> Anyone else have an opinion?
> >>>
> >>> I don't care one way or another, but please, one way
> >>> not two.
> >>
> 
> Same here.
> 
> >> (+cc Bjorn Helgaas, linux-pci)
> >>
> >> Then, how about the following steps?
> >>
> >> 1. Fix ./Documentation/PCI/pci.txt as below.
> >>     (Jingoo Han)
> >>     The ID table is an array of struct pci_device_id entries ending with an
> >>     -all-zero entry; use of the macro DEFINE_PCI_DEVICE_TABLE is the preferred
> >>     -method of declaring the table.  Each entry consists of:
> >>     +all-zero entry; Each entry consists of:
> >>
> >> 2. Fix ./scripts/checkpatch.pl in order to guide to use
> >>      struct pci_device_id instead of DEFINE_PCI_DEVICE_TABLE.
> >>      (Joe Perches)
> >
> > If all DEFINE_PCI_DEVICE_TABLEs are replaced with 'const struct pci_device_id'
> > and these patches are merged through 'driver-core.git', it will be not
> > necessary to fix ./scripts/checkpatch.pl.
> >
> Why not ?

I will replace all DEFINE_PCI_DEVICE_TABLEs with 'const struct pci_device_id',
and remove the definition of DEFINE_PCI_DEVICE_TABLE macro.

--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -631,16 +631,6 @@ struct pci_driver {
 #define        to_pci_driver(drv) container_of(drv, struct pci_driver, driver)

 /**
- * DEFINE_PCI_DEVICE_TABLE - macro used to describe a pci device table
- * @_table: device table name
- *
- * This macro is used to create a struct pci_device_id array (a device table)
- * in a generic manner.
- */
-#define DEFINE_PCI_DEVICE_TABLE(_table) \
-       const struct pci_device_id _table[]
-
-/**

In this case, there is no DEFINE_PCI_DEVICE_TABLE usage
in the kernel. If someone uses DEFINE_PCI_DEVICE_TABLE macro,
it will make  build error.

Best regards,
Jingoo Han

