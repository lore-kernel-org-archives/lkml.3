Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934880Ab3BTIHi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 03:07:38 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:41065 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934313Ab3BTIHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 03:07:37 -0500
X-AuditID: cbfee691-b7f556d000001a24-e8-51248447b16e
From: Jingoo Han <jg1.han@samsung.com>
To: "'Dmitry Torokhov'" <dmitry.torokhov@gmail.com>
Cc: "'Samuel Ortiz'" <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <002601ce0f30$d6b81c40$842854c0$%han@samsung.com>
 <002f01ce0f31$7cb08380$76118a80$%han@samsung.com>
 <20130220073515.GD2648@core.coreip.homeip.net>
In-reply-to: <20130220073515.GD2648@core.coreip.homeip.net>
Subject: Re: [PATCH 10/11] mfd: tps65010: use devm_request_irq() and
 devm_kzalloc()
Date: Wed, 20 Feb 2013 17:07:35 +0900
Message-id: <000a01ce0f41$575e6ce0$061b46a0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4PPNU4EqcsNDlUSXG/o9TWj3aoSQABGSbw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrAIsWRmVeSWpSXmKPExsVy+t8zQ133FpVAg8nNKhaXd81hc2D0+LxJ
	LoAxissmJTUnsyy1SN8ugSujZ/cFtoIe7op/nXNZGhjfcXQxcnJICJhIPDxwjgnCFpO4cG89
	WxcjF4eQwDJGiRW9z1lhii7e6mOGSExnlOh/fYIdwpnNJNE1fQIjSBWbgJrEly+HgRIcHCIC
	hhIz1lSBhJkF8iS+LWqCmrqIUWLPkWNgUzkFrCVOftzABmILC4RKNF5oAYuzCKhKvP7/kxnE
	5hWwlfh/8S4LhC0o8WPyPRaIoVoS63ceZ4Kw5SU2r3nLDLJXQkBd4tFfXZCwiICRxOPOlVAl
	IhL7XrxjBLlBQmARu8T5t39YIHYJSHybfIgFoldWYtMBZoiHJSUOrrjBMoFRYhaSzbOQbJ6F
	ZPMsJCsWMLKsYhRNLUguKE5KLzLVK07MLS7NS9dLzs/dxAiJrYk7GO8fsD7EmAy0fiKzlGhy
	PjA280riDY2NTcxMTE3MLU3NTUkTVhLnlb8kEygkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qB
	0SS8KMe7RPsi19r7tie2XEk4Ei2ymW+BYd6yU1JRF5Y9d5/C8dPyj9r9FS6qeuHrBbVm2fwx
	+1mgd+TnZv8cdidxp3MBCSfeZAlpGrxS0a31yXya1K7Zv7DRfsKBX+cXf1i++eV2/Ril7p9q
	a9mufHm08X6sntjpCZElF0/M+PSnkGmKi9Hfg0osxRmJhlrMRcWJAGjYp2fDAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplleLIzCtJLcpLzFFi42I5/e+xoK57i0qgwY0tChaXd81hc2D0+LxJ
	LoAxqoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdo
	qpJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsI4xo2f3BbaCHu6Kf51zWRoY
	33F0MXJySAiYSFy81ccMYYtJXLi3nq2LkYtDSGA6o0T/6xPsEM5sJomu6RMYQarYBNQkvnw5
	DJTg4BARMJSYsaYKJMwskCfxbVETVPMiRok9R46xgiQ4BawlTn7cwAZiCwuESjReaAGLswio
	Srz+/xNsM6+ArcT/i3dZIGxBiR+T77FADNWSWL/zOBOELS+xec1bZpC9EgLqEo/+6oKERQSM
	JB53roQqEZHY9+Id4wRGoVlIJs1CMmkWkkmzkLQsYGRZxSiaWpBcUJyUnmuoV5yYW1yal66X
	nJ+7iREcuc+kdjCubLA4xCjAwajEw6sxXzlQiDWxrLgy9xCjBAezkghvs5NKoBBvSmJlVWpR
	fnxRaU5q8SHGZKBHJzJLiSbnA5NKXkm8obGJmZGlkZmFkYm5OWnCSuK8jKeeBAgJpCeWpGan
	phakFsFsYeLglGpgnGZhYO9ROJMv17/eSmFKmra8a+c8xapXe5VLIrvzahxz424l52Ww+bN8
	Vyv9GT1JKavb98L+6h/OKx7Ux9zp26GdmKOl/s3p7uKX38OXtf6Utr30/dcMb2th5jXhJi++
	pt+S5H83J6glqmmvi7WzWDj7q5dBCjlHT+sW/37yLOL8iZcPvSuVWIozEg21mIuKEwH0CANw
	IAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, February 20, 2013 4:35 PM, Dmitry Torokhov wrote:

> -----Original Message-----
> From: Dmitry Torokhov [mailto:dmitry.torokhov@gmail.com]
> Sent: Wednesday, February 20, 2013 4:35 PM
> To: Jingoo Han
> Cc: 'Samuel Ortiz'; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH 10/11] mfd: tps65010: use devm_request_irq() and devm_kzalloc()
> 
> On Wed, Feb 20, 2013 at 03:14:05PM +0900, Jingoo Han wrote:
> > Use devm_request_irq() and devm_kzalloc() to make cleanup paths
> > more simple.
> >
> > Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> > ---
> >  drivers/mfd/tps65010.c |   15 +++++----------
> >  1 files changed, 5 insertions(+), 10 deletions(-)
> >
> > diff --git a/drivers/mfd/tps65010.c b/drivers/mfd/tps65010.c
> > index da2691f..a5438cc 100644
> > --- a/drivers/mfd/tps65010.c
> > +++ b/drivers/mfd/tps65010.c
> > @@ -525,11 +525,8 @@ static int __exit tps65010_remove(struct i2c_client *client)
> >  			dev_dbg(&client->dev, "board %s %s err %d\n",
> >  				"teardown", client->name, status);
> >  	}
> > -	if (client->irq > 0)
> > -		free_irq(client->irq, tps);
> >  	cancel_delayed_work_sync(&tps->work);
> >  	debugfs_remove(tps->file);
> > -	kfree(tps);
> >  	the_tps = NULL;
> >  	return 0;
> 
> Nope, again work and IRQ have to be handled in certain order.

Yes, you're right. 
I will use devm_free_irq()

> 
> Thanks.
> 
> --
> Dmitry

