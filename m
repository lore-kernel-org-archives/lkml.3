Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752155Ab3IZGal (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 02:30:41 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:38725 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063Ab3IZGaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 02:30:39 -0400
X-AuditID: cbfee68f-b7f1e6d000004e8d-51-5243d48e8dbb
From: Jingoo Han <jg1.han@samsung.com>
To: "'Sachin Kamat'" <sachin.kamat@linaro.org>
Cc: "'Mark Brown'" <broonie@kernel.org>,
        "'Liam Girdwood'" <lgirdwood@gmail.com>,
        "'LKML'" <linux-kernel@vger.kernel.org>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <000701ceba5c$69459b10$3bd0d130$%han@samsung.com>
 <000c01ceba5d$014e32f0$03ea98d0$%han@samsung.com>
 <CAK9yfHy+96DfxKibu3nnT49EoxH_K9VaL4v+exC86qikxTWYyA@mail.gmail.com>
In-reply-to: <CAK9yfHy+96DfxKibu3nnT49EoxH_K9VaL4v+exC86qikxTWYyA@mail.gmail.com>
Subject: Re: [PATCH V2 06/18] regulator: gpio-regulator: use
 devm_regulator_register()
Date: Thu, 26 Sep 2013 15:30:37 +0900
Message-id: <002c01ceba81$ea03fb00$be0bf100$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac66gHmoBGb6JqUrTbuJmf6ioc9SewAATeqA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJIsWRmVeSWpSXmKPExsVy+t8zfd2+K85BBsc+8llMffiEzeLywkus
	Ft+udDBZXN41h83i5J9eRgdWj52z7rJ7bFrVyeZx59oeNo++LasYPT5vkgtgjeKySUnNySxL
	LdK3S+DK2DT5EFPBFI6Kcw9UGhg3sXUxcnJICJhIbFt4mwXCFpO4cG89UJyLQ0hgGaPE02OX
	WGGKenasY4VITGeUmNl4AqrqF6NEc9NfJpAqNgE1iS9fDrOD2CICOhIrdq1lAiliFpjJKLGn
	dwMLRMcORokbj7sZQao4BYIlduxdAtYhLBAh8XHdcrCjWARUJd68mAZ2FK+ArcSur28YIWxB
	iR+T74HFmQW0JNbvPM4EYctLbF7zlrmLkQPoVnWJR391IY4wklhxfi07RImIxL4X7xhBbpAQ
	uMUucXZ2G9QuAYlvkw+xQPTKSmw6wAzxsqTEwRU3WCYwSsxCsnkWks2zkGyehWTFAkaWVYyi
	qQXJBcVJ6UXGesWJucWleel6yfm5mxgh0dq/g/HuAetDjMlA6ycyS4km5wOjPa8k3tDYzMjC
	1MTU2Mjc0ow0YSVxXrUW60AhgfTEktTs1NSC1KL4otKc1OJDjEwcnFINjJrrPYQvl1z/eGrT
	5Ecf61v/34hJ69pxP9dcle8f/4em3l+SCQ8scx9O3W74XfBUQlih37yfIUrLdWZKn9LtP37m
	Y3iMPfv887M9c5aUNkgqCQixyrJPCTq+0/3frMbI1aH16gd42Jz8VJcUOx84mPZW8uRbURYF
	PRmDh7sjvFg3XxMVzJixUomlOCPRUIu5qDgRAA4eNI3sAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGKsWRmVeSWpSXmKPExsVy+t9jQd2+K85BBjN7uC2mPnzCZnF54SVW
	i29XOpgsLu+aw2Zx8k8vowOrx85Zd9k9Nq3qZPO4c20Pm0ffllWMHp83yQWwRjUw2mSkJqak
	Fimk5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYAbVdSKEvMKQUKBSQW
	Fyvp22GaEBripmsB0xih6xsSBNdjZIAGEtYxZmyafIipYApHxbkHKg2Mm9i6GDk5JARMJHp2
	rGOFsMUkLtxbDxTn4hASmM4oMbPxBJTzi1GiuekvE0gVm4CaxJcvh9lBbBEBHYkVu9YygRQx
	C8xklNjTu4EFomMHo8SNx92MIFWcAsESO/YuAesQFoiQ+LhuOdhuFgFViTcvprGA2LwCthK7
	vr5hhLAFJX5MvgcWZxbQkli/8zgThC0vsXnNW+YuRg6gW9UlHv3VhTjCSGLF+bXsECUiEvte
	vGOcwCg0C8mkWUgmzUIyaRaSlgWMLKsYRVMLkguKk9JzjfSKE3OLS/PS9ZLzczcxglPBM+kd
	jKsaLA4xCnAwKvHwXmB2DhJiTSwrrsw9xCjBwawkwvvNCCjEm5JYWZValB9fVJqTWnyIMRno
	0YnMUqLJ+cA0lVcSb2hsYmZkaWRmYWRibk6asJI478FW60AhgfTEktTs1NSC1CKYLUwcnFIN
	jFsS5KQ8ZLZk6BwL/xRftO+WxKtt8o0fFp7+waK79EG0z3SPqZ6TbV3uftvY1fJOSejHkXNr
	uw5NTmq4LuSdni5odSb7rnQJW4d19qepd35LrpObtHTqJS+5SV0+0nsNtE2cv6vZpna6GXM/
	V3mwk6e+uoxBe77o5lVr1y+9KGaYb1+8IvHDeiWW4oxEQy3mouJEAOaVuL9JAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, September 26, 2013 3:20 PM, Sachin Kamat wrote:
> On 26 September 2013 07:36, Jingoo Han <jg1.han@samsung.com> wrote:
> > Use devm_regulator_register() to make cleanup paths simpler.
> > @@ -349,8 +350,6 @@ static int gpio_regulator_remove(struct platform_device *pdev)
> >  {
> >         struct gpio_regulator_data *drvdata = platform_get_drvdata(pdev);
> >
> > -       regulator_unregister(drvdata->dev);
> > -
> >         gpio_free_array(drvdata->gpios, drvdata->nr_gpios);
> >
> >         kfree(drvdata->states);
> 
> In most of the cases where unregister doesn't happen to be the only or
> last call in the remove path,
> I am not sure if change in ordering wouldn't cause any functional
> issues. For. e.g., in this patch we are freeing the gpios and the
> driver states even before unregistering the device which is logically
> not right.
> 

OK, I see.
I agree with your suggestion in order to keep the code stable.
I will remove this patch from next v3 patch series.

Best regards,
Jingoo Han

