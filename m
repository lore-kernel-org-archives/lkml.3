Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755034Ab3H2CS7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 22:18:59 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:51377 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753372Ab3H2CS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 22:18:57 -0400
X-AuditID: cbfee68d-b7fe86d0000077a5-bc-521eaf90ae40
From: Jingoo Han <jg1.han@samsung.com>
To: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
        "'Anton Vorontsov'" <anton@enomsg.org>
Cc: "'Dan Carpenter'" <dan.carpenter@oracle.com>,
        "'David Woodhouse'" <dwmw2@infradead.org>,
        linux-kernel@vger.kernel.org, "'Joe Perches'" <joe@perches.com>,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Mark Brown'" <broonie@kernel.org>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <005c01ce8cfd$82078af0$8616a0d0$@samsung.com>
 <20130809220451.GG12638@lizard.sbx05730.santaca.wayport.net>
 <003401ce96f2$0f53b840$2dfb28c0$@samsung.com> <20130813090039.GA5604@mwanda>
 <20130828015834.GH10506@lizard>
 <002d01cea395$0ef33ec0$2cd9bc40$%han@samsung.com>
 <20130828083630.GF19256@mwanda> <20130829011848.GA16891@teo>
 <20130829020714.GA26347@kroah.com>
In-reply-to: <20130829020714.GA26347@kroah.com>
Subject: Re: [PATCH 33/35] power: use dev_get_platdata()
Date: Thu, 29 Aug 2013 11:18:56 +0900
Message-id: <002901cea45e$1d0b8b60$5722a220$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac6kXCeuVs/moPsoSpm88sWHcMV1kgAAYX4A
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLIsWRmVeSWpSXmKPExsVy+t8zA90J6+WCDDZtkLCYs34Nm8XBrZoW
	Ux8+YbN4/W86i8XElZOZLZoXr2ezuLzwEqvF7PuPWSwu75rD5sDpMaH/E6PH5hVaHptWdbJ5
	nJjxm8Vj/9w17B4fn95i8fiy6hqzR9+WVYwenzfJBXBGcdmkpOZklqUW6dslcGXMWO5YMI2j
	4uquNywNjGvZuhg5OSQETCQ+7dvACmGLSVy4tx4sLiSwjFFi+hRdmJoN7+cydjFyAcWnM0r8
	WvqSBcL5xSjR+GkLE0gVm4CaxJcvh9lBbBGBWInjax4ygxQxC0xgkvh+bC8TxNhGZokTOxRA
	bE4BfYk9H/cwg9jCAhYS7d2tYM0sAqoS01ons4DYvAK2Ep/670DZghI/Jt8Ds5kFtCQ2b2ti
	hbDlJTaveQs0hwPoVHWJR391IW4wkjhwaD47RImIxL4X78A+kBCYyiHRvWoxI8QuAYlvkw+x
	QPTKSmw6wAzxsaTEwRU3WCYwSsxCsnkWks2zkGyehWTFAkaWVYyiqQXJBcVJ6UWGesWJucWl
	eel6yfm5mxghUd+7g/H2AetDjMlA6ycyS4km5wOTRl5JvKGxmZGFqYmpsZG5pRlpwkrivGot
	1oFCAumJJanZqakFqUXxRaU5qcWHGJk4OKUaGK/095h9+X+3rbwuQujrud+bBTfmL11Q29R7
	iTm4P/vUjLlPAow/uiQcvR9au/9qoilTVMOVh5ELm14uzEhNrMnwy5l1tGv7uZAXC00uLu1u
	kV9y94ruQ4EdXmWnVwl8668N/1ImZi0du7bql7ioM5P2KQn3UA4dG2mznlS5ORKVef/mnF8+
	U4mlOCPRUIu5qDgRAG6p+qoQAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNKsWRmVeSWpSXmKPExsVy+t9jQd0J6+WCDLZ9EraYs34Nm8XBrZoW
	Ux8+YbN4/W86i8XElZOZLZoXr2ezuLzwEqvF7PuPWSwu75rD5sDpMaH/E6PH5hVaHptWdbJ5
	nJjxm8Vj/9w17B4fn95i8fiy6hqzR9+WVYwenzfJBXBGNTDaZKQmpqQWKaTmJeenZOal2yp5
	B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gDdqKRQlphTChQKSCwuVtK3wzQhNMRN1wKm
	MULXNyQIrsfIAA0krGPMmLHcsWAaR8XVXW9YGhjXsnUxcnJICJhIbHg/lxHCFpO4cG89UJyL
	Q0hgOqPEr6UvWSCcX4wSjZ+2MIFUsQmoSXz5cpgdxBYRiJU4vuYhM0gRs8AEJonvx/aCFQkJ
	NDJLnNihAGJzCuhL7Pm4hxnEFhawkGjvbgVrZhFQlZjWOpkFxOYVsJX41H8HyhaU+DH5HpjN
	LKAlsXlbEyuELS+xec1boDkcQKeqSzz6qwtxg5HEgUPz2SFKRCT2vXjHOIFRaBaSSbOQTJqF
	ZNIsJC0LGFlWMYqmFiQXFCel5xrqFSfmFpfmpesl5+duYgQnlWdSOxhXNlgcYhTgYFTi4Y34
	LRskxJpYVlyZe4hRgoNZSYR3SqZckBBvSmJlVWpRfnxRaU5q8SHGZKBHJzJLiSbnAxNeXkm8
	obGJmZGlkZmFkYm5OWnCSuK8B1qtA4UE0hNLUrNTUwtSi2C2MHFwSjUwni7utFi/9tDkj6Ie
	tv89W8wklj1dVNqs89+m2M9hTc7OM21SM64q53TqzF7mGiPV6uX1rlzo2NIHThEbT34r4Mxa
	rOWhL7X/dPaSZmtHhz1Mgleu1OllVL3a9MM+NpZrq+zDlsq1E5mLkyOO3fE/GCTSs3tXckKf
	/IMruxatvFQReTR83V03JZbijERDLeai4kQAlnuq9G4DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, August 29, 2013 11:07 AM, Greg Kroah-Hartman wrote:
> On Wed, Aug 28, 2013 at 06:18:49PM -0700, Anton Vorontsov wrote:
> > On Wed, Aug 28, 2013 at 11:36:30AM +0300, Dan Carpenter wrote:
> > > He doesn't want to take the patch.  He's the maintainer so it's his
> > > choice.  That's the end of the story.
> >
> > Just to clarify: I don't want to take the patch for a reason, not just
> > because of my mood today. Once the patch comes in combination with another
> > patch (or a plan) that actually makes use of the wrapper function, then
> > I'd happily apply/ack it.
> >
> > This is the same story as global checkpatch.pl fixes: they are more harm
> > than good, and without the actual use of the dev_get_platdata(), the patch
> > falls into "global checkpatch.pl fixes" category.
> 
> If you view this as a checkpatch.pl fixup, I'll be glad to take it
> through my tree instead, to ease the patch burden on you :)

Hi Greg,

I agree with you.
Thank you for your suggestion. :-)

Best regards,
Jingoo Han

