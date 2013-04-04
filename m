Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763216Ab3DDGNH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 02:13:07 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:17574 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756356Ab3DDGNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 02:13:04 -0400
X-AuditID: cbfee68f-b7f4a6d000001436-ec-515d19df5eff
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Doug Anderson'" <dianders@chromium.org>
Cc: "'Olof Johansson'" <olof@lixom.net>,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        "'Vivek Gautam'" <gautam.vivek@samsung.com>,
        "'Grant Likely'" <grant.likely@secretlab.ca>,
        "'Rob Herring'" <rob.herring@calxeda.com>,
        "'Rob Landley'" <rob@landley.net>, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1363302046-31684-1-git-send-email-dianders@chromium.org>
 <1363316303-12736-1-git-send-email-dianders@chromium.org>
 <007c01ce212a$059e3340$10da99c0$%han@samsung.com>
In-reply-to: <007c01ce212a$059e3340$10da99c0$%han@samsung.com>
Subject: RE: [PATCH v2] usb: Document clocks in samsung,exynos4210-ehci/ohci
 bindings
Date: Thu, 04 Apr 2013 15:12:46 +0900
Message-id: <27a301ce30fb$6d141400$473c3c00$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4hKP0ou9rx4cJmRtaXjhtfU7dHGQAAF2IQA/SBS9A=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgleLIzCtJLcpLzFFi42I5/e+Zke59ydhAgyPdYhYHZj9ktTi77CCb
	RduVg+wWr85sZLO4vPASq8XCtiUsFpd3zWGzOHX9M5vF4RUHmCzWvZzOYnFsxhJGB26PBZ+v
	sHvMbrjI4vFq9UxWjzvX9rB5nJ+xkNHjyokmVo++LasYPX6+1PH4vEkugDOKyyYlNSezLLVI
	3y6BK2PJtMiCRuaKS72LGBsY1zB1MXJySAiYSJzd8o8RwhaTuHBvPVsXIxeHkMAyRolNO68y
	wxRNnHyBFcQWEljEKPHreDBE0V9GiYbeaWBFbAIaEoffP2MHsUUE/CXWLpvLBFLELHCPSeLZ
	k72MEB1bGSU2P+gGGsXBwSlgJ/FpZhZIg7BAuMSS2afAzmARUJXonH6SBcTmFbCVWPpxDSuE
	LSjxY/I9sDizgJbE+p3HmSBseYnNa94yg4yUEFCXePRXF+IGK4mnL49BlYtI7HvxDuwECYGl
	HBJbe3cwQewSkPg2+RALRK+sxKYDUA9LShxccYNlAqPELCSbZyHZPAvJ5llIVixgZFnFKJpa
	kFxQnJReZKxXnJhbXJqXrpecn7uJEZIK+ncw3j1gfYgxGWj9RGYp0eR8YCrJK4k3NDYzsjA1
	MTU2Mrc0I01YSZxXrcU6UEggPbEkNTs1tSC1KL6oNCe1+BAjEwenVAMjQ/W536YXVnm3GGye
	a3eWxYXTZdrFBv6zW91Wz2X980hvisWt9WEpM+YkFLE8ejr5+ye3L4l7sl8dnXn6bLOmWdnD
	LOG1O2TvenDHCO1+Uj+1Kdw3fsHW2omF/Y1iK/cof3KxYJV9n95csNxw8ZX2Ni2zdydKExe7
	s3RuZak5uImFmVUgsU1NiaU4I9FQi7moOBEALaj1YBsDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKKsWRmVeSWpSXmKPExsVy+t9jAd17krGBBhMXG1kcmP2Q1eLssoNs
	Fm1XDrJbvDqzkc3i8sJLrBYL25awWFzeNYfN4tT1z2wWh1ccYLJY93I6i8WxGUsYHbg9Fny+
	wu4xu+Eii8er1TNZPe5c28PmcX7GQkaPKyeaWD36tqxi9Pj5Usfj8ya5AM6oBkabjNTElNQi
	hdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKBzlRTKEnNKgUIBicXF
	Svp2mCaEhrjpWsA0Ruj6hgTB9RgZoIGEdYwZS6ZFFjQyV1zqXcTYwLiGqYuRk0NCwERi4uQL
	rBC2mMSFe+vZQGwhgUWMEr+OB3cxcgHZfxklGnqnMYMk2AQ0JA6/f8YOYosI+EusXTaXCaSI
	WeAek8SzJ3sZITq2MkpsftANNJaDg1PATuLTzCyQBmGBcIkls08xgtgsAqoSndNPsoDYvAK2
	Eks/rmGFsAUlfky+BxZnFtCSWL/zOBOELS+xec1bZpCREgLqEo/+6kLcYCXx9OUxqHIRiX0v
	3jFOYBSahWTSLCSTZiGZNAtJywJGllWMoqkFyQXFSem5RnrFibnFpXnpesn5uZsYwYnmmfQO
	xlUNFocYBTgYlXh4V/jHBAqxJpYVV+YeYpTgYFYS4XXniQ0U4k1JrKxKLcqPLyrNSS0+xJgM
	9OhEZinR5HxgEswriTc0NjEzsjQyszAyMTcnTVhJnPdgq3WgkEB6YklqdmpqQWoRzBYmDk6p
	BkYG5flHOnRvtl6uuH3FqP9IKs95s8zfb97xP/IzvBRr2erwiP/AtcUn8w9MLyspr9azyvFf
	sXbxhmZFr5W9pu/jDR0iG8P4wiefMluzcg2LSZHcQgdRwU2F6dn86rIWjlePlMlzi5za/+Pz
	V9aGqoye9W6qZ4PLFXOOlj2K8Nr1qvXTx/nKeUosxRmJhlrMRcWJAHdB0u94AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jingoo Han wrote:
> 
> On Friday, March 15, 2013 8:01 AM, Doug Anderson wrote:
> >
> > The exynox4210-ehci and exynos4210-ohci nodes need a clock specified
> > using the common clock framework.  Document it.
> >
> > Signed-off-by: Doug Anderson <dianders@chromium.org>
> 
> It looks good.
> Acked-by: Jingoo Han <jg1.han@samsung.com>
> 
> 
Applied, thanks.

- Kukjin

