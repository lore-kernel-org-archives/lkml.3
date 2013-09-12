Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754222Ab3ILKqx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 06:46:53 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:16941 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752470Ab3ILKqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 06:46:50 -0400
X-AuditID: cbfee691-b7f4a6d0000074fc-4e-52319b99abde
From: Jingoo Han <jg1.han@samsung.com>
To: "'Michal Simek'" <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        monstr@monstr.eu
Cc: "'Jean-Christophe Plagniol-Villard'" <plagnioj@jcrosoft.com>,
        "'Tomi Valkeinen'" <tomi.valkeinen@ti.com>,
        linux-fbdev@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>
References: <7016a90750626ba866dddc6f85cfdd71943f6891.1378965270.git.michal.simek@xilinx.com>
 <940bbdfc5c67282ab461b9c82b55f18fc34c959d.1378965270.git.michal.simek@xilinx.com>
In-reply-to: <940bbdfc5c67282ab461b9c82b55f18fc34c959d.1378965270.git.michal.simek@xilinx.com>
Subject: Re: [PATCH 3/3] video: xilinxfb: Simplify error path
Date: Thu, 12 Sep 2013 19:46:50 +0900
Message-id: <001301ceafa5$630798f0$2916cad0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac6vfNCMoP9FH3Y1SgGCt3dijmelyAAKGrjw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOIsWRmVeSWpSXmKPExsVy+t8zfd2Zsw2DDNactLC4vPASq8WJvg+s
	Fpd3zWGzePcywuLJx9MsFusevmCyWD//FpsDu8erC3dYPP52TWH26NuyitHj+I3tTB6fN8l5
	7P38myWALYrLJiU1J7MstUjfLoEr42DfMZaC+8wVp6dcZWxg7GbuYuTkkBAwkdi39wo7hC0m
	ceHeerYuRi4OIYFljBLPbtyCK3q39iEzRGIRo0TXrC8sEM4vRoknW3uYQKrYBNQkvnw5DDZK
	RCBOovfATkaQImaBtYwSS+ZvYYTo2MwosWLJb1aQKk6BBImmyQ1sILawgK3EisYusDiLgKrE
	s3kHgOIcHLxA8R1XK0DCvAKCEj8m32MBsZkFtCTW7zzOBGHLS2xe85YZpFxCQF3i0V9diBuM
	JC5+62KEKBGR2PfiHdgJEgI/2SWeHL7HBLFKQOLb5EMsEL2yEpsOQH0sKXFwxQ2WCYwSs5Bs
	noVk8ywkm2chWbGAkWUVo2hqQXJBcVJ6kalecWJucWleul5yfu4mRkgkT9zBeP+A9SHGZKD1
	E5mlRJPzgYkgryTe0NjMyMLUxNTYyNzSjDRhJXFe9RbrQCGB9MSS1OzU1ILUovii0pzU4kOM
	TBycUg2MOnO+7e5frG6obPX1pUvI9GiH5H0cMya6dp6btzgjqEpd857Wwr3BO08/S1mYM3NO
	zEvPguuPVibb3vx57ZXh167Vm1wUtnu+OL/i9osFOTu3Mx9K3Bhz5iNLZ9mubQEmUjcb/gU6
	Rz/88OZApFi4+CUey/2J58r2zxbK1kj53x1geFxqQkTYTSWW4oxEQy3mouJEADhPxsr6AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCKsWRmVeSWpSXmKPExsVy+t9jAd2Zsw2DDDZvMbG4vPASq8WJvg+s
	Fpd3zWGzePcywuLJx9MsFusevmCyWD//FpsDu8erC3dYPP52TWH26NuyitHj+I3tTB6fN8l5
	7P38myWALaqB0SYjNTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DX
	LTMH6BYlhbLEnFKgUEBicbGSvh2mCaEhbroWMI0Rur4hQXA9RgZoIGEdY8bBvmMsBfeZK05P
	ucrYwNjN3MXIySEhYCLxbu1DKFtM4sK99WxdjFwcQgKLGCW6Zn1hgXB+MUo82drDBFLFJqAm
	8eXLYXYQW0QgTqL3wE5GkCJmgbWMEkvmb2GE6NjMKLFiyW9WkCpOgQSJpskNbCC2sICtxIrG
	LrA4i4CqxLN5B4DiHBy8QPEdVytAwrwCghI/Jt9jAbGZBbQk1u88zgRhy0tsXvOWGaRcQkBd
	4tFfXYgbjCQufutihCgRkdj34h3jBEahWUgmzUIyaRaSSbOQtCxgZFnFKJpakFxQnJSea6RX
	nJhbXJqXrpecn7uJEZwmnknvYFzVYHGIUYCDUYmHt2OWQZAQa2JZcWXuIUYJDmYlEd7PEw2D
	hHhTEiurUovy44tKc1KLDzEmA/05kVlKNDkfmMLySuINjU3MjCyNzCyMTMzNSRNWEuc92God
	KCSQnliSmp2aWpBaBLOFiYNTqoGRzzFw70PlZTXv/F7fnN3mPnM697nvFgG7X09/IXk3/sjO
	p7/lroa3blfcXDHtm7lGUo9Mje4bWb7iD1fnsH1w03yXunTp2baM1Z+KvNOvSApz82+dL66z
	ZpHZem95/6isewWWxXzhYoXcExl7ZfR90y81vVpY0rA5Yvnzww07n87wmWGSYbNEiaU4I9FQ
	i7moOBEAhBp0dFcDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, September 12, 2013 2:55 PM, Michal Simek wrote:
> 
> devm_iounmap is called automatically that's why remove it from the code
> dev_set_drvdata(dev, NULL) is called by generic code
> after device_release or on probe failure.
> 
> Signed-off-by: Michal Simek <michal.simek@xilinx.com>

Reviewed-by: Jingoo Han <jg1.han@samsung.com>

> ---
>  drivers/video/xilinxfb.c | 28 ++++++----------------------
>  1 file changed, 6 insertions(+), 22 deletions(-)

