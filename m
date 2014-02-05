Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932337AbaBEARX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 19:17:23 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:49530 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764AbaBEART (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 19:17:19 -0500
X-AuditID: cbfee68f-b7f156d00000276c-bd-52f1830d8723
From: Jingoo Han <jg1.han@samsung.com>
To: "'Shuah Khan'" <shuah.kh@samsung.com>,
        "'Rafael J. Wysocki'" <rjw@rjwysocki.net>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Florian Tobias Schandinat'" <FlorianSchandinat@gmx.de>,
        "'Jean-Christophe PLAGNIOL-VILLARD'" <plagnioj@jcrosoft.com>,
        "'Tomi Valkeinen'" <tomi.valkeinen@ti.com>,
        "'Rafael J. Wysocki'" <rafael.j.wysocki@intel.com>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Shuah Khan'" <shuahkhan@gmail.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <2236505237-3336-1-git-send-email-shuah.kh@samsung.com>
 <15798389.lgk83XnI1i@vostro.rjw.lan>
 <001f01cf157f$ca2e8530$5e8b8f90$%han@samsung.com>
 <52DD4045.4050902@samsung.com> <52F1298F.1040903@samsung.com>
In-reply-to: <52F1298F.1040903@samsung.com>
Subject: Re: [PATCH v2] backlight: Convert from Legacy pm ops to dev_pm_ops
Date: Wed, 05 Feb 2014 09:17:16 +0900
Message-id: <000401cf2207$a06765c0$e1363140$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac8h0kwQZivBj+kuS/WbeVAUbnpE0QANHa2w
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjleLIzCtJLcpLzFFi42I5/e+ZoS5v88cgg3d/2Sw6Z15jtLi88BKr
	xYm+D6wWl3fNYbNY9/AFk8XjFW/ZLc6cBkrs3vWU1eLLZy6Lrz8dLNbPv8XmwO2xc9Zddo8P
	H+M8Fu95yeTx6sIdFo8tV9tZPPbM/8Hq0bdlFaPH8RvbmTw+b5IL4IzisklJzcksSy3St0vg
	yjj6r5+9YCtrxY//p5kbGOezdDFyckgImEj0TP/MCGGLSVy4t56ti5GLQ0hgGaPE/CudrDBF
	nXc3QSUWMUqs/joZyvnFKHF421o2kCo2ATWJL18Os4PYIgIhEtumXGYHKWIW6GSWOPL4NhNE
	xz1GiY9PX4FVcQpoS7yYfYwJxBYW8JboOLMGzGYRUJW49OcXWA2vgK3Exi+v2SBsQYkfk+8B
	Hc4BNFVdYsqUXJAws4C8xOY1b5lBwhJA4Ud/dSFuMJJ407ONEaJERGLfi3dQby7kkJh2LBZi
	k4DEt8mHWCBaZSU2HWCGKJGUOLjiBssERolZSPbOQtg7C8neWUgWLGBkWcUomlqQXFCclF5k
	rFecmFtcmpeul5yfu4kRkgb6dzDePWB9iDEZaPtEZinR5HxgGskriTc0NjOyMDUxNTYytzQj
	TVhJnPf+w6QgIYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYwBzvVf2yfu/LleTS7jzXqp9O2M
	qm7uPR8OByw4dmrbUqe5by7uZforl9nApvE3VfZXS9v/a12//ot7h5va7C9ldpoyKbwm8eOb
	df8f8rz48bF2x+8epxPtE1xucB7Zpjh7wVruuR6vZxa3JnyYuZ2lQGzuZxbzOonNnA++zm6c
	V/ZhavqqGer/lViKMxINtZiLihMBOyWAbxkDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCKsWRmVeSWpSXmKPExsVy+t9jAV3e5o9BBn8XM1l0zrzGaHF54SVW
	ixN9H1gtLu+aw2ax7uELJovHK96yW5w5DZTYvespq8WXz1wWX386WKyff4vNgdtj56y77B4f
	PsZ5LN7zksnj1YU7LB5brrazeOyZ/4PVo2/LKkaP4ze2M3l83iQXwBnVwGiTkZqYklqkkJqX
	nJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA3SskkJZYk4pUCggsbhYSd8O
	04TQEDddC5jGCF3fkCC4HiMDNJCwjjHj6L9+9oKtrBU//p9mbmCcz9LFyMkhIWAi0Xl3ExuE
	LSZx4d56IJuLQ0hgEaPE6q+ToZxfjBKHt60Fq2ITUJP48uUwO4gtIhAisW3KZXaQImaBTmaJ
	I49vM0F03GOU+Pj0FVgVp4C2xIvZx5hAbGEBb4mOM2vAbBYBVYlLf36B1fAK2Eps/PKaDcIW
	lPgx+R7QfRxAU9UlpkzJBQkzC8hLbF7zlhkkLAEUfvRXF+IGI4k3PdsYIUpEJPa9eMc4gVFo
	FpJBsxAGzUIyaBaSjgWMLKsYRVMLkguKk9JzDfWKE3OLS/PS9ZLzczcxgtPMM6kdjCsbLA4x
	CnAwKvHwGgh/DBJiTSwrrsw9xCjBwawkwmv2+UOQEG9KYmVValF+fFFpTmrxIcZkoDcnMkuJ
	JucDU2BeSbyhsYmZkaWRmYWRibk5acJK4rwHWq0DhQTSE0tSs1NTC1KLYLYwcXBKNTA2r81R
	PffIUnHa7fyGrRZcmw811L462nRRo+x8hqBkxv8f8aVpyorZ4f8efFV30rlx6NWF87GMq86f
	27H9qO6yWxOXvuoz6XueaB+U8E+X76uM5rnO+AXsfH/UZv2z+D+p7dEcPp2Jv7dq1i1MY9jg
	+2SG8xZzrmfHGH+8ZphzIpC9xGfRK11/JZbijERDLeai4kQAz+It/HcDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, February 05, 2014 2:55 AM, Shuah Khan wrote:
> On 01/20/2014 08:27 AM, Shuah Khan wrote:
> > On 01/19/2014 06:34 PM, Jingoo Han wrote:
> >> On Monday, January 20, 2014 12:37 AM, Rafael J. Wysocki wrote:
> 
> > Rafael/Jingoo Han,
> >
> > I did send the v3 patch with the typo fixed. Here is the link:
> >
> > http://lkml.indiana.edu/hypermail/linux/kernel/1306.0/00219.html
> >
> > This is a while back. I will rebase and res-test and send it.
> >
> 
> Checked 3.14-rc1 and patch v3 is in there.
> 
> commit 3601792e7b68150420ea8dc129e26e167c0484d8

OK, I see. I checked that it was already merged to
mainline kernel. Thank you.

Best regards,
Jingoo Han

