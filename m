Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755157AbaADCrq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 21:47:46 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:8663 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754213AbaADCrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 21:47:43 -0500
X-AuditID: cbfee68e-b7f566d000002344-17-52c7764d76b3
From: kgene@kernel.org
To: "'Tomasz Figa'" <t.figa@samsung.com>,
        "'Mike Turquette'" <mturquette@linaro.org>
Cc: "'Andrew Bresticker'" <abrestic@chromium.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        "'linux-samsung-soc'" <linux-samsung-soc@vger.kernel.org>,
        "'Sylwester Nawrocki'" <sylvester.nawrocki@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        "'Padmavathi Venna'" <padma.v@samsung.com>
References: <1380046016-5811-1-git-send-email-abrestic@chromium.org>
 <20131127184145.16819.44300@quantum> <529BBB9E.40300@samsung.com>
 <1592382.OOUUI06mrc@amdc1227>
In-reply-to: <1592382.OOUUI06mrc@amdc1227>
Subject: RE: [PATCH V4 1/6] clk: exynos-audss: convert to platform device
Date: Sat, 04 Jan 2014 11:47:41 +0900
Message-id: <230001cf08f7$568ded80$03a9c880$@kernel.org>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQIFk8Y75iXmmTzNRR5Z67QzfLeapgJuhQx7AlgrWKIBQxSTTpnWd/LA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgleLIzCtJLcpLzFFi42I5/e+Zsa5v2fEgg1s7bSxWvv/LaDH/yDlW
	i02Pr7FaLGxbwmJxedccNosZ5/cxWTydcJHN4vfN72wW8z7vZLJYP+M1iwOXx+yGiyweO2fd
	Zfe4c20Pm8fmJfUefVtWMXp83iQXwBbFZZOSmpNZllqkb5fAlfHi8D/2gqucFcturmFtYFzI
	3sXIwSEhYCLx4GVSFyMnkCkmceHeejYQW0hgGaPExj9OEHETiTU/zgGVcwHFpzNK7LqzhAXC
	+csocebiZbBBbEDdU59IgzQIC2hJLNzSxAJiiwgESBxf18AEUs8scIpJonX3bCaIDSsYJWYe
	0wGxOYEatj07wwLR7Cnxef0RMJtFQFXi2c5bYDavgIXE98d32SFsQYkfk++BxZmBetfvPM4E
	YctLbF7zlhniagWJHWdfM0Ic4SZxdO8DqBoRiX0v3jGCHCQhMJFDonf+PFaIZQIS3yYfYoGE
	iqzEpgNQcyQlDq64wTKBUXIWktWzkKyehWT1LCQrFjCyrGIUTS1ILihOSi8y0itOzC0uzUvX
	S87P3cQIif2+HYw3D1gfYkwGWj+RWUo0OR+YOvJK4g2NzYwsTE1MjY3MLc1IE1YS5130MClI
	SCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dUA+PahrSYntlcTwrfVl4pZXz/YMmqDTeCznxddtjR
	u9ru1GEut5luxWLuOytdtetPdfAvrPOx1NZ6euO9tUTSrU/3Y1VXbm1++a+94/ufrQs1th7O
	tlv/b0F9i/DaB3FF5Tu3uITmzz8XMq/H5XZMmB6DOWuVoPjqXsHDlZN7vfuWf1tr5B64XEWJ
	pTgj0VCLuag4EQCPVTXeEwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPKsWRmVeSWpSXmKPExsVy+t9jQV3fsuNBBnMvCFisfP+X0WL+kXOs
	FpseX2O1WNi2hMXi8q45bBYzzu9jsng64SKbxe+b39ks5n3eyWSxfsZrFgcuj9kNF1k8ds66
	y+5x59oeNo/NS+o9+rasYvT4vEkugC2qgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX
	0NLCXEkhLzE31VbJxSdA1y0zB+g0JYWyxJxSoFBAYnGxkr4dpgmhIW66FjCNEbq+IUFwPUYG
	aCBhHWPGi8P/2AuuclYsu7mGtYFxIXsXIyeHhICJxJof56BsMYkL99azdTFycQgJTGeU2HVn
	CQuE85dR4szFy0BVHBxsQFVTn0iDNAgLaEks3NLEAmKLCARIHF/XwARSzyxwikmidfdsJpCE
	kMAKRomZx3RAbE6ghm3PzrBANHtKfF5/BMxmEVCVeLbzFpjNK2Ah8f3xXXYIW1Dix+R7YHFm
	oN71O48zQdjyEpvXvGWGuFpBYsfZ14wQR7hJHN37AKpGRGLfi3eMExiFZyEZNQvJqFlIRs1C
	0rKAkWUVo2hqQXJBcVJ6rpFecWJucWleul5yfu4mRnByeSa9g3FVg8UhRgEORiUe3gOnjwUJ
	sSaWFVfmHmKU4GBWEuGd6Xo8SIg3JbGyKrUoP76oNCe1+BBjMtCnE5mlRJPzgYkvryTe0NjE
	zMjSyMzCyMTcnDRhJXHeg63WgUIC6YklqdmpqQWpRTBbmDg4pRoYoz1WzT0tHPvnm1/wxX5N
	nm95u/SDakTP/i9btfZy7YGjDhKlxikCxzmaarmqDl9l4vh2R7/h1bR78zKdcr7EqTzn/1EQ
	//mhwpFXu/2kfju9ZO92NPS9/K78XhkPG9elkDjen+7eEyYodbo6LNzv2bZ8u+7uecpHzy/6
	dPrKhL4XJfVd3qIKSizFGYmGWsxFxYkAyOpDpXIDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tomasz Figa wrote:
> 
> Hi Kukjin, Mike,
> 
> On Monday 02 of December 2013 07:43:42 Kukjin Kim wrote:
> > On 11/28/13 03:41, Mike Turquette wrote:
> > > Quoting Padma Venkat (2013-11-25 22:29:44)
> > >> Hi Mike and Kukjin,
> > >>
> > >> On Tue, Oct 8, 2013 at 10:23 PM, Andrew Bresticker
> > >> <abrestic@chromium.org>  wrote:
> > >>> Hi Mike and Kukjin,
> > >>>
> > >>> Any decisions regarding this patchset?  I believe all comments have
> > >>> been addressed.
> > >>>
> > >>> Thanks,
> > >>> Andrew
> > >>
> > >> Any decisions on this patchset. These can be applied directly on
> > >> linux-samsung tree.
> > >
> > > For all of the clk parts:
> > >
> > > Acked-by: Mike Turquette<mturquette@linaro.org>
> > >
> > > I'm happy to take them in as part of a pull request.
> > >
> > OK, Mike, I will take this series into samsung tree and let me send a
> > pull request for your clk tree to avoid useless merge conflicts.
> 
- some persons in Cc

> Hmm, I can't find this series in any tree, so I guess it has been lost
> in action.
> 
Oops, sorry about that :-(

> Should I take it through samsung-clk tree with your acks?
> 
Tomasz, yes please take this series with my ack.

Thanks,
Kukjin

