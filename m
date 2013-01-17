Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758730Ab3AQEHX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 23:07:23 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:10814 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758201Ab3AQEHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 23:07:21 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-9f-50f778f7786b
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
Date: Wed, 16 Jan 2013 20:06:59 -0800
Message-id: <0c7d01cdf468$1ad400d0$507c0270$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQJ5C+EMbh6xTcK1+iIQ4sOv+ooGYQHRD6J6lugvqBA=
Content-language: en-us
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHIsWRmVeSWpSXmKPExsVy+t8zfd3vFd8DDDZ1Wlhc3jWHzeLgwjZG
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDJ2n7jKVtDKUnFq1yHmBsZG5i5GTg4JAROJ+R8XsEHY
	YhIX7q0Hsrk4hASWMUocWfKQCabo07+3UIlFjBIXthxjB0kICfxllLjerQ5iswloSBx+/wws
	LiKgK9H3bz4TSAOzwEVGif+TpzNDdDczStxacYwFpIpTwF1i/cvrYCuEBfwl+h99BrNZBFQl
	jr2eAlbDK2ApcaX7AyOELSjxY/I9sDizgJbE+p3HmSBseYnNa95C/aMgsePsa0aIK6wknrQu
	YYeoEZeY9OAhO8R8AYlvkw8BzeEAqpeV2HQA7DYJgVXsEn//P4OGhaTEwRU3WCYwSsxCsnoW
	ktWzkKyehWTFAkaWVYyiqQXJBcVJ6bmGesWJucWleel6yfm5mxghkSa1g3Flg8UhRgEORiUe
	XsPL3wKEWBPLiitzDzFKcDArifCuyfseIMSbklhZlVqUH19UmpNafIjRB+jyicxSosn5wCSQ
	VxJvaGxsYmZiamJuaWpuikNYSZyX8dSTACGB9MSS1OzU1ILUIphxTBycUg2Mug61rVdW/fW8
	/nLlRLOkRXY1J7jffnjxz1uioW5Zr4+GlPjT2/fO9ftKRv3xstzfKSDfePP7ZqGZHqX9LKJ2
	54QWfljOrPG1/WdKd3tapIjEbNc1pxTN8/wSt0TKvDvuJ2rdNive5sObts0vfdvVxVdJ5DWw
	pq0sy56sd9RyifeszZcEWviUWIozEg21mIuKEwFFWRfg4QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLIsWRmVeSWpSXmKPExsVy+t9jAd3vFd8DDDZtNrG4vGsOm8XBhW2M
	DkwenzfJBTBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE
	6Lpl5gCNVlIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jFm7D5xla2glaXi
	1K5DzA2MjcxdjJwcEgImEp/+vWWDsMUkLtxbD2RzcQgJLGKUuLDlGDtIQkjgL6PE9W51EJtN
	QEPi8PtnYHERAV2Jvn/zmUAamAUuMkr8nzydGaK7mVHi1opjLCBVnALuEutfXmcCsYUF/CX6
	H30Gs1kEVCWOvZ4CVsMrYClxpfsDI4QtKPFj8j2wOLOAlsT6nceZIGx5ic1r3kKdrSCx4+xr
	RogrrCSetC5hh6gRl5j04CH7BEahWUhGzUIyahaSUbOQtCxgZFnFKJpakFxQnJSea6hXnJhb
	XJqXrpecn7uJERzHz6R2MK5ssDjEKMDBqMTDa3j5W4AQa2JZcWXuIUYJDmYlEd41ed8DhHhT
	EiurUovy44tKc1KLDzH6AH06kVlKNDkfmGLySuINjU3MjCyNzCyMTMzNcQgrifMynnoSICSQ
	nliSmp2aWpBaBDOOiYNTqoHRRayPa1r9Fo1p029pt3yQd+V6yBLwaqtUyJqIr0ltP66o+h+d
	YCTxwvnt6d6ZLh93eLG4GT05IP773S7+5oPsnz8abREPEdFvz/5Vot/9W15wMVMTY8YB1S3c
	AYKpab67XvJtZlcxt5A7XuB59pCq6xflFaes82YsXs+7JMTp6O1/zx33XeNRYinOSDTUYi4q
	TgQAjMzSxRADAAA=
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
> 
Oops, I missed above e-mail. Anyway, really?

Let me look at soon and I will fix.

Thanks for your information.

- Kukjin

