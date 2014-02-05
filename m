Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752157AbaBEKlJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 05:41:09 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:11847 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469AbaBEKlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 05:41:07 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-e7-52f21541d46a
Message-id: <1391596863.3726.6.camel@AMDC1943>
Subject: Re: [PATCH 05/18] mfd: max14577: Use of_match_ptr() in i2c_driver
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Date: Wed, 05 Feb 2014 11:41:03 +0100
In-reply-to: <20140203093013.GG13529@lee--X1>
References: <1390911522-28209-1-git-send-email-k.kozlowski@samsung.com>
 <1390911522-28209-6-git-send-email-k.kozlowski@samsung.com>
 <20140203093013.GG13529@lee--X1>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrILMWRmVeSWpSXmKPExsVy+t/xK7qOop+CDC5dYbGY+vAJm8X1L89Z
	Lc42vWG3uP/1KKPFtysdTBabHl9jtbi8aw6bxdojd9ktbjeuYLM43c3qwOWxc9Zddo9NqzrZ
	PO5c28PmMe9koMfmJfUefVtWMXp83iQXwB7FZZOSmpNZllqkb5fAlXG57wt7wXb2ip3d21ga
	GBvZuhg5OSQETCRurrzPDmGLSVy4tx4sLiSwlFFi3/IoCPszo8T3C04gNq+AnsSBhvlMILaw
	gJfEo/bJYPVsAsYSm5cvAbI5OEQEVCTOvTHvYuTiYBZ4zCSx5PYHJpA4i4CqxKGdmSDlnAK6
	ErcuHGWGGL+CUeLJvlAQm1lAXWLSvEXMEOcoSexu72SHiMtLbF7zlhniBEGJH5PvsUxgFJiF
	pGUWkrJZSMoWMDKvYhRNLU0uKE5KzzXUK07MLS7NS9dLzs/dxAiJhi87GBcfszrEKMDBqMTD
	2yH6MUiINbGsuDL3EKMEB7OSCG+jwKcgId6UxMqq1KL8+KLSnNTiQ4xMHJxSDYwLnRan3LMQ
	YnDP35m2cldu64FVTbef1vFde7DE5NPPkym1EcELn3150H9N7hyj2fOihZN/VJ/d7/Pd3bCp
	W4lpo+i0hDcnVmu5xb8VtTpSbdFuorLSii3SxvZd/gKlj6deMSaIPJsfVK8Q+cLqUm9E4atw
	j81TPqfkmMTuFbZsUP74ssBkcZcSS3FGoqEWc1FxIgCj6oR4ZAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-02-03 at 09:30 +0000, Lee Jones wrote:
> > Use of_match_ptr() in assignment of i2c_driver.of_match_table.
> > 
> > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > Cc: Kyungmin Park <kyungmin.park@samsung.com>
> > Cc: Marek Szyprowski <m.szyprowski@samsung.com>
> > ---
> >  drivers/mfd/max14577.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/mfd/max14577.c b/drivers/mfd/max14577.c
> > index 2ac2f2d7cea6..75b37082a3fe 100644
> > --- a/drivers/mfd/max14577.c
> > +++ b/drivers/mfd/max14577.c
> > @@ -224,7 +224,7 @@ static struct i2c_driver max14577_i2c_driver = {
> >  		.name = "max14577",
> >  		.owner = THIS_MODULE,
> >  		.pm = &max14577_pm,
> > -		.of_match_table = max14577_dt_match,
> > +		.of_match_table = of_match_ptr(max14577_dt_match),
> 
> Are you sure this is required?

No, it was my mistake. Please ignore this patch.

Krzysztof

