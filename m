Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752855Ab3DKEJN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 00:09:13 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:40118 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752475Ab3DKEJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 00:09:10 -0400
X-AuditID: cbfee690-b7f656d0000007e3-0a-5166375ea347
From: Jingoo Han <jg1.han@samsung.com>
To: "'Vivek Gautam'" <gautam.vivek@samsung.com>,
        "'Andrew Morton'" <akpm@linuxfoundation.org>
Cc: "'Sylwester Nawrocki'" <s.nawrocki@samsung.com>,
        rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, a.zummo@towertech.it,
        kgene.kim@samsung.com, thomas.ab@samsung.com, dianders@chromium.org,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1365517660-9322-1-git-send-email-gautam.vivek@samsung.com>
 <516535E4.5060308@samsung.com>
In-reply-to: <516535E4.5060308@samsung.com>
Subject: Re: [PATCH] rtc: rtc-s3c: use clk_prepare_enable and
 clk_disable_unprepare
Date: Thu, 11 Apr 2013 13:09:01 +0900
Message-id: <002e01ce366a$4c9f1390$e5dd3ab0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac410NhgtQuJCfmiTMmE35oMaonYpgAmS2Xg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplleLIzCtJLcpLzFFi42I5/e+Zvm6ceVqgwZf5fBZLLl5lt+j7MZfR
	4uyyg2wWbVcOsltcXniJ1aJ3wVU2i8u75rBZzDi/j8lif2cHo8XhN+2sFh3LGC2OzVjC6MDj
	MbvhIovHnokn2TzuXNvD5rF/7hp2j74tqxg9ps/7yeTxeZNcAHsUl01Kak5mWWqRvl0CV8bH
	KQdZC1YJVhy/spK1gfEJbxcjJ4eEgIlES9tnJghbTOLCvfVsXYxcHEICyxglLl/7xwhTtPpk
	MzNEYjqjxOGfDewQzi9GibNvJoO1swmoSXz5cpgdxBYRiJa4dauLBaSIWeAwk8Sb5n9sIAkh
	gQyJqdevgzVwCmhLrHh8kxnEFhYIldj3+wiYzSKgKrFq9WIWEJtXwFbiyZfdULagxI/J98Bs
	ZgEtic3bmlghbHmJzWveAvVyAJ2qLvHory7EDUYSj559hSoXkdj34h0jyD0SAnM5JKYdaWKD
	2CUg8W3yIRaIXlmJTQeYIT6WlDi44gbLBEaJWUg2z0KyeRaSzbOQrFjAyLKKUTS1ILmgOCm9
	yESvODG3uDQvXS85P3cTIyQJTNjBeO+A9SHGZKD1E5mlRJPzgUkkryTe0NjMyMLUxNTYyNzS
	jDRhJXFe9RbrQCGB9MSS1OzU1ILUovii0pzU4kOMTBycUg2MeRUCaYobZj2wdrsvl92Tk5fz
	7p/tAd+n15+uXS8oKv702LbHRxauMp3DZFrBn6jUqH9R4qbx+Tc7F1l1Wp6bGXw+/tkWgeyN
	fx1rH1VNejLDm3fT1Q3r/3V3ONxvcsic27P/SUL7DJHbbtmzOBMYfyTFPZv98UB/0h5L4VNc
	X7c/XOC77lbTYSWW4oxEQy3mouJEAB2ei9EYAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEKsWRmVeSWpSXmKPExsVy+t9jQd0487RAgyUv2S2WXLzKbtH3Yy6j
	xdllB9ks2q4cZLe4vPASq0XvgqtsFpd3zWGzmHF+H5PF/s4ORovDb9pZLTqWMVocm7GE0YHH
	Y3bDRRaPPRNPsnncubaHzWP/3DXsHn1bVjF6TJ/3k8nj8ya5APaoBkabjNTElNQihdS85PyU
	zLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKBLlRTKEnNKgUIBicXFSvp2mCaE
	hrjpWsA0Ruj6hgTB9RgZoIGEdYwZH6ccZC1YJVhx/MpK1gbGJ7xdjJwcEgImEqtPNjND2GIS
	F+6tZ+ti5OIQEpjOKHH4ZwM7hPOLUeLsm8lMIFVsAmoSX74cZgexRQSiJW7d6mIBKWIWOMwk
	8ab5HxtIQkggQ2Lq9etgDZwC2hIrHt8EWyEsECqx7/cRMJtFQFVi1erFLCA2r4CtxJMvu6Fs
	QYkfk++B2cwCWhKbtzWxQtjyEpvXvAXq5QA6VV3i0V9diBuMJB49+wpVLiKx78U7xgmMQrOQ
	TJqFZNIsJJNmIWlZwMiyilE0tSC5oDgpPddIrzgxt7g0L10vOT93EyM4xTyT3sG4qsHiEKMA
	B6MSD++JhtRAIdbEsuLK3EOMEhzMSiK8XDuBQrwpiZVVqUX58UWlOanFhxiTgR6dyCwlmpwP
	TH95JfGGxiZmRpZGZhZGJubmpAkrifMebLUOFBJITyxJzU5NLUgtgtnCxMEp1cBovpJVMedO
	smqZi4+bebDavv337Usr/bx2228MrE04ZR+mPHFyQd7Whwf3cSSFOT/xPl05x5g/Zt/+Hvn4
	FUr/2QRnnpvxo8vivoj5MT7r5LdJNinMiokeHjI1T77WvV8eImuqyrHlfnicYZjs6iV1XQca
	pruv+j2lb6Hd/Fs/C0QWHW2bX6vEUpyRaKjFXFScCACuxt6ldQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, April 10, 2013 6:50 PM, Sylwester Nawrocki wrote:
> On 04/09/2013 04:27 PM, Vivek Gautam wrote:
> > From: Thomas Abraham <thomas.abraham@linaro.org>
> >
> > Convert clk_enable/clk_disable to clk_prepare_enable/clk_disable_unprepare
> > calls as required by common clock framework.
> >
> > Signed-off-by: Thomas Abraham <thomas.abraham@linaro.org>
> > Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> 
> Thanks Vivek.
> 
> Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

CC'ed Andrew Morton

It looks good.
Reviewed-by: Jingoo Han <jg1.han@samsung.com>

> 
> > ---
> >
> > The v1 of this patch is pretty old, but the change needs to be merged to
> > avoid getting those needless WARN_ON() dumps on console.
> >
> > Changes from v1:
> >  - Not using clk_disable_unprepare() at the end of s3c_rtc_probe(), since
> >    this will unprepare the rtc clock which is again getting used in other
> >    funtions later.
> >  - Using clk_unprepare() at the remove() instead to fix things up.
> >
> >  drivers/rtc/rtc-s3c.c |    5 +++--
> >  1 files changed, 3 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/rtc/rtc-s3c.c b/drivers/rtc/rtc-s3c.c
> > index fb994e9..e3528c9 100644
> > --- a/drivers/rtc/rtc-s3c.c
> > +++ b/drivers/rtc/rtc-s3c.c
> > @@ -430,6 +430,7 @@ static int s3c_rtc_remove(struct platform_device *dev)
> >
> >  	s3c_rtc_setaie(&dev->dev, 0);
> >
> > +	clk_unprepare(rtc_clk);
> >  	rtc_clk = NULL;
> >
> >  	return 0;
> > @@ -498,7 +499,7 @@ static int s3c_rtc_probe(struct platform_device *pdev)
> >  		return ret;
> >  	}
> >
> > -	clk_enable(rtc_clk);
> > +	clk_prepare_enable(rtc_clk);
> >
> >  	/* check to see if everything is setup correctly */
> >
> > @@ -578,7 +579,7 @@ static int s3c_rtc_probe(struct platform_device *pdev)
> >
> >   err_nortc:
> >  	s3c_rtc_enable(pdev, 0);
> > -	clk_disable(rtc_clk);
> > +	clk_disable_unprepare(rtc_clk);
> >
> >  	return ret;
> >  }
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

