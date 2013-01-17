Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758714Ab3AQELF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 23:11:05 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:49093 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757317Ab3AQELC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 23:11:02 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-2e-50f779d4a3cd
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Stephen Rothwell'" <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Stephen Warren'" <swarren@nvidia.com>,
        "'Olof Johansson'" <olof@lixom.net>, "'Arnd Bergmann'" <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org
References: <20130111153206.e075edb9b1e4a38d90f23ab6@canb.auug.org.au>
 <20130117145324.3f1f27fb5902b5a03135bf06@canb.auug.org.au>
In-reply-to: <20130117145324.3f1f27fb5902b5a03135bf06@canb.auug.org.au>
Subject: RE: linux-next: manual merge of the samsung tree with the arm-soc tree
Date: Wed, 16 Jan 2013 20:10:39 -0800
Message-id: <0c8401cdf468$9e920c00$dbb62400$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQJ5C+EMbh6xTcK1+iIQ4sOv+ooGYQHRD6J6lugw1UA=
Content-language: en-us
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPIsWRmVeSWpSXmKPExsVy+t8zA90rld8DDJ68N7W4vGsOm8XBhW2M
	DkwenzfJBTBGcdmkpOZklqUW6dslcGXcXTOPtaCNpWJdx3bGBsYm5i5GTg4JAROJ/idzGCFs
	MYkL99azdTFycQgJzGaU+DCrnw2m6E/LC6jEdEaJ/d2rmCCcv4wSix/1soBUsQloSBx+/4wd
	xBYR0JXo+zcfrIhZ4CKjxP/J05khOpoZJW6tOAbWwSngLrH+5XUmEFtYwF+i/9FnMJtFQFXi
	35cNrCA2r4ClxLZF3UwQtqDEj8n3wHqZBbQk1u88zgRhy0tsXvMW6iEFiR1nXzNCXGElMaHj
	MxtEjbjEpAcP2SHmC0h8m3wIaA4HUL2sxKYDYLdJCKxil9h6bwoLxBxJiYMrbrBMYJSYhWT1
	LCSrZyFZPQvJigWMLKsYRVMLkguKk9JzDfWKE3OLS/PS9ZLzczcxQmJNagfjygaLQ4wCHIxK
	PLyGl78FCLEmlhVX5h5ilOBgVhLhXZP3PUCINyWxsiq1KD++qDQntfgQow/Q5ROZpUST84Fp
	IK8k3tDY2MTMxNTE3NLU3BSHsJI4L+OpJwFCAumJJanZqakFqUUw45g4OKUaGItOdVZMzbCs
	rZ2sIB1wP/Hpb4eiPzqFtnN13n1IvFO3MP9qY4fBElOr8CexTHaLj8cVbk/c6C9gvUpBOSdv
	8/LUGQ92bT+6j81zff6tS7/uL+nXUEgRUZz598h3/m/MVgte9cS//reCy+GWrF5zY7nh1NMh
	O9oV13zaaZnJIBEkHR9aq71zlxJLcUaioRZzUXEiAEKOw8/iAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHIsWRmVeSWpSXmKPExsVy+t9jQd0rld8DDO5sN7S4vGsOm8XBhW2M
	DkwenzfJBTBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE
	6Lpl5gCNVlIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jFm3F0zj7WgjaVi
	Xcd2xgbGJuYuRk4OCQETiT8tL9ggbDGJC/fWA9lcHEIC0xkl9nevYoJw/jJKLH7UywJSxSag
	IXH4/TN2EFtEQFei7998sCJmgYuMEv8nT2eG6GhmlLi14hhYB6eAu8T6l9eZQGxhAX+J/kef
	wWwWAVWJf182sILYvAKWEtsWdTNB2IISPybfA+tlFtCSWL/zOBOELS+xec1bqLsVJHacfc0I
	cYWVxISOz2wQNeISkx48ZJ/AKDQLyahZSEbNQjJqFpKWBYwsqxhFUwuSC4qT0nMN9YoTc4tL
	89L1kvNzNzGCI/mZ1A7GlQ0WhxgFOBiVeHgNL38LEGJNLCuuzD3EKMHBrCTCuybve4AQb0pi
	ZVVqUX58UWlOavEhRh+gTycyS4km5wOTTF5JvKGxiZmRpZGZhZGJuTkOYSVxXsZTTwKEBNIT
	S1KzU1MLUotgxjFxcEo1MFZYrPKV3D5lwz/GyAC2D2GcCqLrTO6YNSRG1+xxPl5RWGZT1uGT
	uIFDc9HnbPvyCR9msfyvW1yzK691xf2vTzLfaxxrX/L+cr/90uZ7rXmnZ/744Ll/zZ+9z18E
	vfz+sCJQ6sXhsDoF9gLGhil/nW63L634NbG98lDZlOdtZ6b6/w+4tXzCpFlKLMUZiYZazEXF
	iQBiYEBsEQMAAA==
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> 
> Hi Kukjin,
> 
Hi,

> On Fri, 11 Jan 2013 15:32:06 +1100 Stephen Rothwell <sfr@canb.auug.org.au>
> wrote:
> >
> > Today's linux-next merge of the samsung tree got conflicts in
> > many files with the arm-soc tree.
> >
> > I just dropped the samsung tree for today.  Please have a look and try
to
> > fix this mess up, thanks.
> 
> Ping?

Oops, I missed above e-mail. Anyway, really?

Let me look at it soon and I will fix.

Thanks for your information.

- Kukjin

