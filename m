Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750997Ab3AQFDC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 00:03:02 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:19519 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707Ab3AQFDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 00:03:00 -0500
X-AuditID: cbfee61b-b7f616d00000319b-d9-50f78602e3fc
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Stephen Rothwell'" <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Stephen Warren'" <swarren@nvidia.com>,
        "'Olof Johansson'" <olof@lixom.net>, "'Arnd Bergmann'" <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, cpgs@samsung.com
References: <20130111153206.e075edb9b1e4a38d90f23ab6@canb.auug.org.au>
 <20130117145324.3f1f27fb5902b5a03135bf06@canb.auug.org.au>
In-reply-to: 
Subject: RE: linux-next: manual merge of the samsung tree with the arm-soc tree
Date: Wed, 16 Jan 2013 21:02:37 -0800
Message-id: <0c9001cdf46f$e0a4db20$a1ee9160$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQJ5C+EMbh6xTcK1+iIQ4sOv+ooGYQHRD6J6lugw1UCAAAvckA==
Content-language: en-us
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDIsWRmVeSWpSXmKPExsVy+t8zI12mtu8BBl2NQhaXd81hszi4sI3R
	gcnj8ya5AMYoLpuU1JzMstQifbsEroxFW5pZCn6wVUw9PY2lgXEGaxcjJ4eEgInEi/8LmCBs
	MYkL99azgdhCAssYJX4+havpmfWVuYuRCyg+nVFia99cRgjnL6PEiu4uRpAqNgENicPvn7GD
	2CICuhJ9/+YzgRQxCzxllJg7eR8rREczo8StFcdYQKo4BXgk1v3pZAaxhQX8JfoffQbq4OBg
	EVCVWP5XHyTMK2Apcb/1MwuELSjxY/I9MJtZQEti/c7jTBC2vMTmNW+ZIU5VkNhx9jUjyBgR
	ASeJWX+EIUrEJSY9eAh2G4uAgMS3yYdYQEokBGQlNh0Ae0xCYB27xJdXnWwQYyQlDq64wTKB
	UWIWks2zkGyehWTzLCQrFjCyrGIUTS1ILihOSs810itOzC0uzUvXS87P3cQIiTLpHYyrGiwO
	MQpwMCrx8Bpd/hYgxJpYVlyZe4hRgoNZSYR3Td73ACHelMTKqtSi/Pii0pzU4kOMPkCXT2SW
	Ek3OByaAvJJ4Q2NjEzMTUxNzS1NzUxzCSuK8jKeeBAgJpCeWpGanphakFsGMY+LglGpgrGl/
	vPbHxKnXup2vzf1TEiv63dlwwqZVF7cd4tVY+yHqrLaD3Kp3FTrmbXeOvWtf9f+u+NTOekH2
	5bIitVprnTf9q5PkKElaZH5qemfzwyfW18OWvBR21v40p8ZMVIBBPC6UMT2oa/mltFtB93PZ
	OhUW/Yv5usV1wf2Oxw5uUwxfPPX4liJzXImlOCPRUIu5qDgRAC598GHfAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDIsWRmVeSWpSXmKPExsVy+t9jQV2mtu8BBh8vcltc3jWHzeLgwjZG
	ByaPz5vkAhijGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwC
	dN0yc4BGKymUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJ6xgzFm1pZin4wVYx
	9fQ0lgbGGaxdjJwcEgImEj2zvjJD2GISF+6tZ+ti5OIQEpjOKLG1by4jhPOXUWJFdxcjSBWb
	gIbE4ffP2EFsEQFdib5/85lAipgFnjJKzJ28jxWio5lR4taKYywgVZwCPBLr/nSC7RAW8Jfo
	f/QZqIODg0VAVWL5X32QMK+ApcT91s8sELagxI/J98BsZgEtifU7jzNB2PISm9e8hTpVQWLH
	2deMIGNEBJwkZv0RhigRl5j04CH7BEahWUgmzUIyaRaSSbOQtCxgZFnFKJpakFxQnJSea6RX
	nJhbXJqXrpecn7uJERzFz6R3MK5qsDjEKMDBqMTDa3T5W4AQa2JZcWXuIUYJDmYlEd41ed8D
	hHhTEiurUovy44tKc1KLDzH6AP05kVlKNDkfmGDySuINjU3MjCyNzCyMTMzNcQgrifMynnoS
	ICSQnliSmp2aWpBaBDOOiYNTqoGx4vuepX8yJeOF+mZIsz7pYa/u5fiyRSr73tbKeMPuoGdn
	D2pVbD7btbzFQYPn6cL2o67ONT/W7X85a97rD25dyV/mtWz7afGnas6t0+8zT2Yd9gt6UzR5
	bcoMJeNY0RnrGu78i+3pWLDzRG18UUZoQ7NVblKz06nKS+Uh/U0Ry5O8w7wnRbQqsRRnJBpq
	MRcVJwIAWFgx7A8DAAA=
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kukjin Kim wrote:
> 
> Stephen Rothwell wrote:
> >
> > Hi Kukjin,
> >
> Hi,
> 
> > On Fri, 11 Jan 2013 15:32:06 +1100 Stephen Rothwell
> <sfr@canb.auug.org.au>
> > wrote:
> > >
> > > Today's linux-next merge of the samsung tree got conflicts in
> > > many files with the arm-soc tree.
> > >
> > > I just dropped the samsung tree for today.  Please have a look and try
to
> > > fix this mess up, thanks.
> >
> > Ping?
> 
> Oops, I missed above e-mail. Anyway, really?
> 
> Let me look at it soon and I will fix.
> 
> Thanks for your information.
> 
Hmm, updating timer patches in Samsung tree cause the merge conflicts with
arm-soc, so for now I dropped them in my tree just now.
And note that regarding topic branch which are including it will be
re-worked soon :-)

Now to merge Samsung tree for linux-next should be fine.

Thanks again.

- Kukjin

