Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755764Ab3FBW50 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jun 2013 18:57:26 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:9767 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753968Ab3FBW5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jun 2013 18:57:19 -0400
X-AuditID: cbfee691-b7fef6d000002d62-68-51abcdccdf0d
From: Jonghwan Choi <jhbird.choi@samsung.com>
To: "'Jonathan Cameron'" <jic23@jic23.retrosnub.co.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "'Wei Yongjun'" <yongjun_wei@trendmicro.com.cn>,
        "'Jonathan Cameron'" <jic23@kernel.org>
References: <000101ce5828$545e10b0$fd1a3210$%choi@samsung.com>
 <51AB60F1.5060002@jic23.retrosnub.co.uk>
In-reply-to: <51AB60F1.5060002@jic23.retrosnub.co.uk>
Subject: RE: [PATCH 3.9-stable] staging:iio:light:tsl2x7x: fix the error
 handling in tsl2x7x_probe()
Date: Mon, 03 Jun 2013 07:57:15 +0900
Message-id: <001c01ce5fe4$86dfa8f0$949efad0$%choi@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac5fo6MKQ1BBdC5pTM6ke6oX0ab26QAQNvnw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMIsWRmVeSWpSXmKPExsVy+t8zI90zZ1cHGjxeJ2jxaeU2JosHTauY
	LC7vmsNmsWDjI0aLnes62R1YPR6u7Wbz2LSqk81j6b2jjB6fN8kFsERx2aSk5mSWpRbp2yVw
	ZbxZ+4+xYKNoxZUH19gbGB8JdDFyckgImEicntnNCmGLSVy4t56ti5GLQ0hgGaPE/XVr2GGK
	Tr1dCZVYxChx6MV0FgjnL6PEvwXvGEGq2AR0JY6t3wI2SgSo49z63WBFzAKTGCWmXVjGDJIQ
	EsiU2Ph9JtBYDg5OAVOJf4u8QcLCAmkSa2/9YAKxWQRUJS5cPs4GYvMK2Elcf/2UHcIWlPgx
	+R4LiM0soCWxfudxJghbXmLzmrfMICMlBNQlHv3VhTjBSOL+kWfMECUiEvtegJzJBVRyi11i
	+/F+qF0CEt8mH2KB6JWV2HSAGeJhSYmDK26wTGCUmIVk8ywkm2ch2TwLyYoFjCyrGEVTC5IL
	ipPSi0z1ihNzi0vz0vWS83M3MUIidOIOxvsHrA8xJgOtn8gsJZqcD4zwvJJ4Q2MzIwtTE1Nj
	I3NLM9KElcR51VusA4UE0hNLUrNTUwtSi+KLSnNSiw8xMnFwSjUwnghilJGXfH/9C8fTkIeW
	U29c3ix48c5djw6pw/E9XX1cRzVDLxdMkdn87NF7HsuozPDtzKFxXC/n6eZP7nBnmlpkuO8+
	e/uyxEsJR8yNbk+d79lr9/BDkN2q+Ualu+dYs7CvfRTwNOpq01LV4PSNVfefsR7pFFj2Qu28
	5oztZ5h5Z+/t7iu4psRSnJFoqMVcVJwIAMcvBdPmAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrAKsWRmVeSWpSXmKPExsVy+t9jAd0zZ1cHGrz9yWPxaeU2JosHTauY
	LC7vmsNmsWDjI0aLnes62R1YPR6u7Wbz2LSqk81j6b2jjB6fN8kFsEQ1MNpkpCampBYppOYl
	56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAC1WUihLzCkFCgUkFhcr6dth
	mhAa4qZrAdMYoesbEgTXY2SABhLWMWa8WfuPsWCjaMWVB9fYGxgfCXQxcnJICJhInHq7kg3C
	FpO4cG89kM3FISSwiFHi0IvpLBDOX0aJfwveMYJUsQnoShxbv4UVxBYB6j63fjdYEbPAJEaJ
	aReWMYMkhAQyJTZ+n8nexcjBwSlgKvFvkTdIWFggTWLtrR9MIDaLgKrEhcvHwTbzCthJXH/9
	lB3CFpT4MfkeC4jNLKAlsX7ncSYIW15i85q3zCAjJQTUJR791YU4wUji/pFnzBAlIhL7Xrxj
	nMAoNAvJpFlIJs1CMmkWkpYFjCyrGEVTC5ILipPScw31ihNzi0vz0vWS83M3MYLj/5nUDsaV
	DRaHGAU4GJV4eDu2rwoUYk0sK67MPcQowcGsJMKbvHJ1oBBvSmJlVWpRfnxRaU5q8SHGZKBH
	JzJLiSbnA1NTXkm8obGJmZGlkZmFkYm5OWnCSuK8B1qtA4UE0hNLUrNTUwtSi2C2MHFwSjUw
	stpK3Es6zik11/sSV6PQc+9ruQ8rJkdYfFp7nrOp52fx3S8zxetSWx2spr5rD63Ie/xKrH/e
	xFDtoJJdJk5mYkcjWjoZZKZu8HmhNmWR/u1enb6JcrtFdG1cL6U+c5j+nZnL73VQ4fIDf+u/
	rPZjn+R87uiTpR51Ce2MC86kf9jh27eYOXWzEktxRqKhFnNRcSIAh6+4wUMDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the kind reply.

Best Regards.~

> -----Original Message-----
> From: Jonathan Cameron [mailto:jic23@jic23.retrosnub.co.uk]
> Sent: Monday, June 03, 2013 12:13 AM
> To: Jonghwan Choi
> Cc: linux-kernel@vger.kernel.org; stable@vger.kernel.org; 'Wei Yongjun';
> 'Jonathan Cameron'
> Subject: Re: [PATCH 3.9-stable] staging:iio:light:tsl2x7x: fix the error
> handling in tsl2x7x_probe()
> 
> On 05/24/2013 03:42 AM, Jonghwan Choi wrote:
> > This patch looks like it should be in the 3.9-stable tree, should we
> apply
> > it?
> It's a pretty unlikely problem to hit in reality so up to you on whether
> you think it worth picking up.  Also note that only the -EINVAL bit
> is actually a fix. The rest of it was some incidental tidying up.
> 
> Jonathan
> 
> > ------------------
> >
> > From: "Wei Yongjun <yongjun_wei@trendmicro.com.cn>"
> >
> > commit 3b813798aa7030f1beef638c75f8b0008f737a82 upstream
> >
> > Fix to return -EINVAL in the i2c device found error handling
> > case instead of 0, as done elsewhere in this function.
> > And also correct the fail1 and fail2 lable to do the right thing.
> >
> > Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> > Signed-off-by: Jonathan Cameron <jic23@kernel.org>
> > Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
> > ---
> >  drivers/staging/iio/light/tsl2x7x_core.c |    9 +++++----
> >  1 file changed, 5 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/staging/iio/light/tsl2x7x_core.c
> > b/drivers/staging/iio/light/tsl2x7x_core.c
> > index a58731e..2d40c03 100644
> > --- a/drivers/staging/iio/light/tsl2x7x_core.c
> > +++ b/drivers/staging/iio/light/tsl2x7x_core.c
> > @@ -1869,6 +1869,7 @@ static int tsl2x7x_probe(struct i2c_client
> *clientp,
> >  		dev_info(&chip->client->dev,
> >  				"%s: i2c device found does not match
> > expected id\n",
> >  				__func__);
> > +		ret = -EINVAL;
> >  		goto fail1;
> >  	}
> >
> > @@ -1907,7 +1908,7 @@ static int tsl2x7x_probe(struct i2c_client
> *clientp,
> >  		if (ret) {
> >  			dev_err(&clientp->dev,
> >  				"%s: irq request failed", __func__);
> > -			goto fail2;
> > +			goto fail1;
> >  		}
> >  	}
> >
> > @@ -1920,17 +1921,17 @@ static int tsl2x7x_probe(struct i2c_client
> *clientp,
> >  	if (ret) {
> >  		dev_err(&clientp->dev,
> >  			"%s: iio registration failed\n", __func__);
> > -		goto fail1;
> > +		goto fail2;
> >  	}
> >
> >  	dev_info(&clientp->dev, "%s Light sensor found.\n", id->name);
> >
> >  	return 0;
> >
> > -fail1:
> > +fail2:
> >  	if (clientp->irq)
> >  		free_irq(clientp->irq, indio_dev);
> > -fail2:
> > +fail1:
> >  	iio_device_free(indio_dev);
> >
> >  	return ret;

