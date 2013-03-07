Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932244Ab3CGBOZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 20:14:25 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:34140 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752224Ab3CGBOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 20:14:23 -0500
X-AuditID: cbfee68f-b7f6a6d000004969-3e-5137e9ecc318
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Russell King - ARM Linux'" <linux@arm.linux.org.uk>
Cc: "'Paul Bolle'" <pebolle@tiscali.nl>, "'Ben Dooks'" <ben-linux@fluff.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1362609234.28137.2.camel@x61.thuisdomein>
 <013a01ce1ac7$11b287d0$35179770$%kim@samsung.com>
 <1362615081.28137.5.camel@x61.thuisdomein>
 <014601ce1acd$bc63d480$352b7d80$%kim@samsung.com>
 <20130307005206.GZ17833@n2100.arm.linux.org.uk>
In-reply-to: <20130307005206.GZ17833@n2100.arm.linux.org.uk>
Subject: RE: [PATCH] ARM: S3C24XX: drop "select MACH_N35"
Date: Thu, 07 Mar 2013 10:14:19 +0900
Message-id: <015001ce1ad1$185e66d0$491b3470$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4azgPR//Tw7Mv+RwqhgmC1mZKCDwAAvdkw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKIsWRmVeSWpSXmKPExsVy+t8zY903L80DDaadELS4vGsOm8WM8/uY
	HJg8Pm+SC2CM4rJJSc3JLEst0rdL4MrYtGELW8FZ1op5Z2+yNjB2snQxcnBICJhILHkn3sXI
	CWSKSVy4t56ti5GLQ0hgGaPE7Zan7BAJE4m3c6axQiQWMUp8nfqPCcL5yyix8vo8JpAqNgEN
	icPvn4F1iAiYS8ybOQmsiFlgM6PE3s8vWOE6blztYgSp4hSwkdix7x+YLSxgKfFqxU1WkJtY
	BFQlJr5mBgnzCthK9D3cD2ULSvyYfI8FxGYW0JJYv/M4E4QtL7F5zVtmiHfUJR791YW4wUhi
	8fwjbBAlIhL7XrxjBDlBQmAZu8SpTQfB1rIICEh8m3wIGhSyEpsOMEN8LClxcMUNlgmMErOQ
	bJ6FZPMsJJtnIVmxgJFlFaNoakFyQXFSepGxXnFibnFpXrpecn7uJkZIlPXvYLx7wPoQYzLQ
	+onMUqLJ+cAozSuJNzQ2NjEzMTUxtzQ1NyVNWEmcV/6STKCQQHpiSWp2ampBalF8UWlOavEh
	RiYOTqkGxvjVmmvmWJ1znmw5e17vw8Dqz42+OjJSTUnrWLZu/F6b+CvBReOOCievytnV1hPe
	OB0+V2HoOEHOrnOG3vJtf7YaFZZ+7f8YzlKk83H5E50t+X1ny05J2iW7PZvfl8Fut/cxl3K0
	ptJBZe8PYVktD7+I9ezt2ey599+0Sc7CzgZqK6OSOP6cVWIpzkg01GIuKk4EANDVWOnIAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMKsWRmVeSWpSXmKPExsVy+t9jAd03L80DDU7O5rO4vGsOm8WM8/uY
	HJg8Pm+SC2CMamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ
	0HXLzAEaraRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGPM2LRhC1vBWdaK
	eWdvsjYwdrJ0MXJySAiYSLydM40VwhaTuHBvPVsXIxeHkMAiRomvU/8xQTh/GSVWXp/HBFLF
	JqAhcfj9M3YQW0TAXGLezElgRcwCmxkl9n5+wQrXceNqFyNIFaeAjcSOff/AbGEBS4lXK24C
	FXFwsAioSkx8zQwS5hWwleh7uB/KFpT4Mfke2HnMAloS63ceZ4Kw5SU2r3nLDNIqIaAu8eiv
	LsQNRhKL5x9hgygRkdj34h3jBEahWUgmzUIyaRaSSbOQtCxgZFnFKJpakFxQnJSea6RXnJhb
	XJqXrpecn7uJERzFz6R3MK5qsDjEKMDBqMTDuzHHPFCINbGsuDL3EKMEB7OSCO/dJUAh3pTE
	yqrUovz4otKc1OJDjMlAf05klhJNzgcmmLySeENjEzMjSyMzCyMTc3PShJXEeRlPPQkQEkhP
	LEnNTk0tSC2C2cLEwSnVwFhuaTPxwKwavd+c8mI8cbp2Uq6+JU/WHLhr2LngnUXjn4J7W0Qj
	asLY1Mw6J4qsVOBQM5uw0olzm6S54P8FSRKdrdtk/9pPfjnHd5MBzwWJa48Dk87vls1gWvHY
	u+b7zte8rbW8P/lM/3I9OhHw3rpY3zsm5GnJHk3hyExGoR8n9D3l31pfV2Ipzkg01GIuKk4E
	AN5aOXAmAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King - ARM Linux wrote:
> 
> On Thu, Mar 07, 2013 at 09:50:17AM +0900, Kukjin Kim wrote:
> > Paul Bolle wrote:
> > >
> > > On Thu, 2013-03-07 at 09:02 +0900, Kukjin Kim wrote:
> > >
> > > > BTW, so the machine type can be removed at arch/arm/tools/mach-types
> as
> > > well.
> > >
> > > Well, that file has a big comment on top, containing the line:
> > >     Please do not send patches to this file; it is automatically
> > > generated!
> > >
> > > So I didn't dare to touch it.
> > >
> > Yeah, I know.
> >
> > It will be handled by Russell King :-)
> 
> And deleting entries from it is pointless if they've ever been in the
> kernel.

OK, I see and agree.

Thanks.

- Kukjin

