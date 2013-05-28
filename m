Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932441Ab3E1Xyf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 19:54:35 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:61253 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932080Ab3E1Xyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 19:54:33 -0400
X-AuditID: cbfee68e-b7f276d000002279-fd-51a543b73409
From: Jingoo Han <jg1.han@samsung.com>
To: "'Herbert Xu'" <herbert@gondor.hengli.com.au>
Cc: linux-kernel@vger.kernel.org, "'Matt Mackall'" <mpm@selenic.com>,
        "'Deepak Saxena'" <dsaxena@plexity.net>,
        Jingoo Han <jg1.han@samsung.com>
References: <002801ce57a0$1f004ba0$5d00e2e0$@samsung.com>
 <20130528091615.GB24414@gondor.apana.org.au>
In-reply-to: <20130528091615.GB24414@gondor.apana.org.au>
Subject: Re: [PATCH] hwrng: use platform_{get,set}_drvdata()
Date: Wed, 29 May 2013 08:54:30 +0900
Message-id: <001401ce5bfe$b23c9a60$16b5cf20$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQJu93ei87CZ15IdEX315rmkuWQPxQLN3/LGl8OetpA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGIsWRmVeSWpSXmKPExsVy+t8zY93tzksDDT7sEbRon/yNyaL7lYzF
	5YWXWC0u75rDZrFgWx+jA6vHtgOqHo9bWpk9+rasYvToe7mB0ePzJrkA1igum5TUnMyy1CJ9
	uwSujLVLXjIVPGKrmHluPnsD4yrWLkYODgkBE4k3f8u7GDmBTDGJC/fWs3UxcnEICSxjlNhx
	tIkFImEisfjiciaIxHRGie7X25khnF+MErv2zGMFqWITUJP48uUwO4gtIqAn0be+kRGkiFmg
	l1Hi0oz7YEVCAhkSW9f1sYGs5hSwlJj+sRokLCxgI9G2YDtYL4uAqsTUjqlgm3mBSs6fP80O
	YQtK/Jh8DyzOLKAlsX7ncSYIW15i85q3zBCXKkjsOPuaEeIGK4ktS14yQ9SISOx78Q7sHgmB
	W+wSO352M0MsE5D4NvkQCyQoZCU2HYCaIylxcMUNlgmMErOQrJ6FZPUsJKtnIVmxgJFlFaNo
	akFyQXFSepGRXnFibnFpXrpecn7uJkZInPbtYLx5wPoQYzLQ+onMUqLJ+cA4zyuJNzQ2M7Iw
	NTE1NjK3NCNNWEmcV63FOlBIID2xJDU7NbUgtSi+qDQntfgQIxMHp1QDY4SjEPuTdbzt0gwt
	QpcX3DaR6ez/67irZs/SUtdr5jslpYXqF9YJn229sp7RcoeboO2l4wmH3gfrt2Ue7Y4LePlj
	m3T9/pL5p91tVkeHv4i8mzxlWeaDjJY04ynhLDuFU3L/eJn65f/cXb790KvVF0+Jr81R+nvv
	wSOzB+YXlG9vPnjcpe7tFCWW4oxEQy3mouJEAHCbz33pAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCKsWRmVeSWpSXmKPExsVy+t9jQd3tzksDDXqX8Fq0T/7GZNH9Ssbi
	8sJLrBaXd81hs1iwrY/RgdVj2wFVj8ctrcwefVtWMXr0vdzA6PF5k1wAa1QDo01GamJKapFC
	al5yfkpmXrqtkndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0G4lhbLEnFKgUEBicbGS
	vh2mCaEhbroWMI0Rur4hQXA9RgZoIGEdY8baJS+ZCh6xVcw8N5+9gXEVaxcjJ4eEgInE4ovL
	mSBsMYkL99azdTFycQgJTGeU6H69nRnC+cUosWvPPLAONgE1iS9fDrOD2CICehJ96xsZQYqY
	BXoZJS7NuA9WJCSQIbF1XR/QKA4OTgFLiekfq0HCwgI2Em0LtoP1sgioSkztmMoCYvMClZw/
	f5odwhaU+DH5HlicWUBLYv3O40wQtrzE5jVvmSEuVZDYcfY1I8QNVhJblrxkhqgRkdj34h3j
	BEahWUhGzUIyahaSUbOQtCxgZFnFKJpakFxQnJSea6hXnJhbXJqXrpecn7uJEZwGnkntYFzZ
	YHGIUYCDUYmHl+HXkkAh1sSy4srcQ4wSHMxKIrypgksDhXhTEiurUovy44tKc1KLDzEmA306
	kVlKNDkfmKLySuINjU3MjCyNzCyMTMzNSRNWEuc90GodKCSQnliSmp2aWpBaBLOFiYNTqoGR
	zej2g/NiD5NnWS7/yzh7+sVshbajh0X6LXkN4xtlOwyPdNVEr8s/YfPu0rI3haHBawRbtjd1
	ztmvxvF/6e3841+TFy4+M6/f1v/ytmmq1x/8jNK/GJnna9O1pk5DpJN70bJstU+37CSW7+d5
	cEYye/UZc1XPPzPPmyqzRd/gPJU3Q/rgQjF9JZbijERDLeai4kQAJUKe8kcDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, May 28, 2013 6:16 PM, Herbert Xu wrote:
> On Thu, May 23, 2013 at 07:27:26PM +0900, Jingoo Han wrote:
> > Use the wrapper functions for getting and setting the driver data using
> > platform_device instead of using dev_{get,set}_drvdata() with &pdev->dev,
> > so we can directly pass a struct platform_device.
> >
> > Also, unnecessary dev_set_drvdata() is removed, because the driver core
> > clears the driver data to NULL after device_release or on probe failure.
> >
> > Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> 
> Sorry but this patch doesn't apply against the current cryptodev
> tree.  If you are basing your patch on another tree, please submit
> the patch there.

Hi Herbert Xu,

I will make the patch based on your "cryptodev" tree,
and will send it, soon. :)

Best regards,
Jingoo Han

> 
> Thanks,
> --


