Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798Ab3K0AOd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 19:14:33 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:25370 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359Ab3K0AOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:14:20 -0500
X-AuditID: cbfee68d-b7f1a6d0000055a7-aa-5295395aad39
From: Jingoo Han <jg1.han@samsung.com>
To: "'Brian Norris'" <computersforpeace@gmail.com>
Cc: "'Wei Yongjun'" <weiyj.lk@gmail.com>,
        "'David Woodhouse'" <dwmw2@infradead.org>,
        "'Bill Pemberton'" <wfp5p@virginia.edu>,
        "'Artem Bityutskiy'" <artem.bityutskiy@linux.intel.com>,
        "'Wei Yongjun'" <yongjun_wei@trendmicro.com.cn>,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <CAPgLHd-qf8Zj0gWgJh3_WMZOAx5-H6aABrVFqRsAw=XkOfDdmw@mail.gmail.com>
 <20131126235026.GN9468@ld-irv-0074.broadcom.com>
In-reply-to: <20131126235026.GN9468@ld-irv-0074.broadcom.com>
Subject: Re: [PATCH] MIPS: Alchemy: add missing platform_set_drvdata() in
 au1550nd_probe()
Date: Wed, 27 Nov 2013 09:14:18 +0900
Message-id: <004e01ceeb05$9d579690$d806c3b0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7rAkwg6JcyGtjaQneCsn3pEwbWDQAANjKw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOIsWRmVeSWpSXmKPExsVy+t8zA90oy6lBBg/vWFm8efyM2eLIhbXM
	FhNXTma2uLzwEqvF5V1z2Cx2Ny1jt/hw6Sizxar/Z1ksdq7rZHfg9Ng56y67x+YVWh7zTgZ6
	bF5S79G3ZRWjx9J7Rxk9Pm+S83hx/CVTAEcUl01Kak5mWWqRvl0CV0bf+udsBauEK15u/cDW
	wPiRr4uRk0NCwESi4dYuJghbTOLCvfVsXYxcHEICyxglvt18zg5TtHDFNCaIxHRGie5Ny5kh
	nF+MEjtef2YFqWITUJP48uUwUAcHh4iAgcSPN5kgYWaB40wS35cXQdS3Mkq0TjgJNpVTwFZi
	7ePXYL3CAjESx5+sAzuDRUBVYv+UL2wgNi9QTeul51C2oMSPyfdYIIZqSWze1sQKYctLbF7z
	lhlkr4SAusSjv7ogYREBI4n7q+6yQZSISOx78Y4R4pmJHBKr2w0gVglIfJt8iAWiVVZi0wFm
	iBJJiYMrbrBMYJSYhWTxLCSLZyFZPAvJhgWMLKsYRVMLkguKk9KLDPWKE3OLS/PS9ZLzczcx
	QiK9dwfj7QPWhxiTgdZPZJYSTc4HJoq8knhDYzMjC1MTU2Mjc0sz0oSVxHmTHiYFCQmkJ5ak
	ZqemFqQWxReV5qQWH2Jk4uCUamCM4dimzph73s5Z3VptZq97ZlGdSvr6g2Vct5wvf1D1ejaf
	13vj5Ugt5fV1i1sCTWeu59r02Dx/3TLVgqvBAROEv4vuzNgld262ZOhd203TzFK2bP3QV+Z4
	abOuU5LefkPubbJMqVbbfz8VPl2Q9yEuxn+NatB8VtnwczKP1hp9+BOjMifN47ESS3FGoqEW
	c1FxIgCFGDfbCgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKKsWRmVeSWpSXmKPExsVy+t9jQd0oy6lBBmvemFq8efyM2eLIhbXM
	FhNXTma2uLzwEqvF5V1z2Cx2Ny1jt/hw6Sizxar/Z1ksdq7rZHfg9Ng56y67x+YVWh7zTgZ6
	bF5S79G3ZRWjx9J7Rxk9Pm+S83hx/CVTAEdUA6NNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZ
	gaGuoaWFuZJCXmJuqq2Si0+ArltmDtB1SgpliTmlQKGAxOJiJX07TBNCQ9x0LWAaI3R9Q4Lg
	eowM0EDCOsaMvvXP2QpWCVe83PqBrYHxI18XIyeHhICJxMIV05ggbDGJC/fWs3UxcnEICUxn
	lOjetJwZwvnFKLHj9WdWkCo2ATWJL18Os3cxcnCICBhI/HiTCRJmFjjOJPF9eRFEfSujROuE
	k+wgCU4BW4m1j1+D9QoLxEgcf7IObBuLgKrE/ilf2EBsXqCa1kvPoWxBiR+T77FADNWS2Lyt
	iRXClpfYvOYtM8heCQF1iUd/dUHCIgJGEvdX3WWDKBGR2PfiHeMERqFZSCbNQjJpFpJJs5C0
	LGBkWcUomlqQXFCclJ5rpFecmFtcmpeul5yfu4kRnEieSe9gXNVgcYhRgINRiYd3wuUpQUKs
	iWXFlbmHGCU4mJVEeE0VpgYJ8aYkVlalFuXHF5XmpBYfYkwGenQis5Rocj4wyeWVxBsam5gZ
	WRqZWRiZmJuTJqwkznuw1TpQSCA9sSQ1OzW1ILUIZgsTB6dUAyNbboeoYuM5p4wAruOeTr7l
	C5VM3x250K95L/mRkpp3szWn/9NlxoevboibtIOfpfja3XMN+5+US32/evonZ8XMvu+vQqU+
	zXkv3RDemC+4bLKQwMMDujOkxd9N5TDOPpz40PNzysNTVYt23rb4n31FkWWHXP7WC4W9r5a6
	Rs6w9TMU8rOQfaHEUpyRaKjFXFScCABBaWXPaAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, November 27, 2013 8:50 AM, Brian Norris wrote:

Hi Brian Norris,

I added my questions as below. :-)

> On Mon, Nov 11, 2013 at 02:18:29PM +0800, Wei Yongjun wrote:
> > From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> >
> > Add missing platform_set_drvdata() in au1550nd_probe(), otherwise
> > calling platform_get_drvdata() in remove returns NULL.
> 
> An alternative solution: just allocate ctx with devm_kzalloc().Then you
> don't have to kfree() it at all.

Even if devm_kzalloc() is used, missing platform_set_drvdata() will
be still necessary.

static int au1550nd_remove(struct platform_device *pdev)
{
	struct au1550nd_ctx *ctx = platform_get_drvdata(pdev);
	.....

	nand_release(&ctx->info);

'ctx' is still used. Also, in order to use 'ctx',
platform_get_drvdata(pdev) should be called.

> 
> I don't mind one solution over the other too much. Let me know which
> you'd prefer.
> 
> > Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> > ---
> >  drivers/mtd/nand/au1550nd.c | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/drivers/mtd/nand/au1550nd.c b/drivers/mtd/nand/au1550nd.c
> > index ae8dd7c..909b673 100644
> > --- a/drivers/mtd/nand/au1550nd.c
> > +++ b/drivers/mtd/nand/au1550nd.c
> > @@ -480,6 +480,8 @@ static int au1550nd_probe(struct platform_device *pdev)
> >
> >  	mtd_device_register(&ctx->info, pd->parts, pd->num_parts);
> >
> > +	platform_set_drvdata(pdev, ctx);
> > +
> 
> Personally, I'd choose to call platform_set_drvdata() earlier in the
> probe routine (e.g., immediately after its allocation), in case we end
> up calling platform_get_drvdata() from some sub-routine in the future.

Do you mean the following?
But, most drivers calls platform_set_drvdata() later in the probe routine.

static int au1550nd_probe(struct platform_device *pdev)
{
        struct au1550nd_platdata *pd;
        struct au1550nd_ctx *ctx;
        struct nand_chip *this;
        struct resource *r;
        int ret, cs;

        pd = dev_get_platdata(&pdev->dev);
        if (!pd) {
                dev_err(&pdev->dev, "missing platform data\n");
                return -ENODEV;
        }

        ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
        if (!ctx) {
                dev_err(&pdev->dev, "no memory for NAND context\n");
                return -ENOMEM;
        }

+	platform_set_drvdata(pdev, ctx);
+

Best regards,
Jingoo Han

