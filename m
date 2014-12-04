Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751018AbaLDFAh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 00:00:37 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:60949 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725AbaLDFAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 00:00:35 -0500
X-AuditID: cbfee691-f79b86d000004a5a-33-547fea70eab0
Message-id: <547FEA74.1010900@samsung.com>
Date: Thu, 04 Dec 2014 10:30:36 +0530
From: Pankaj Dubey <pankaj.dubey@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.2.0
MIME-version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org
Cc: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        kgene.kim@samsung.com, linux@arm.linux.org.uk, heiko@sntech.de,
        Linus Walleij <linus.walleij@linaro.org>, tomasz.figa@gmail.com,
        Rob Herring <robh+dt@kernel.org>, thomas.ab@samsung.com,
        Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH v4 1/2] soc: samsung: add exynos chipid driver support
References: <1417594658-2931-1-git-send-email-pankaj.dubey@samsung.com>
 <1417594658-2931-2-git-send-email-pankaj.dubey@samsung.com>
 <19026872.NZqUJn3Abb@wuerfel>
In-reply-to: <19026872.NZqUJn3Abb@wuerfel>
Content-type: text/plain; charset=windows-1252; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPIsWRmVeSWpSXmKPExsWyRsSkVrfwVX2IQc9/Zou/k46xWxz4s4PR
	4v+j16wWvQuusllM+bOcyWLT42usFpd3zWGzmHF+H5PF7cu8Fq17j7BbdCxjtFi16w+jA49H
	S3MPm8fvX5MYPXbOusvusWlVJ5vHnWt72Dw2L6n36NuyitFj+7V5zB6fN8kFcEZx2aSk5mSW
	pRbp2yVwZWxu+cdUcJG34uDbRSwNjOe4uhg5OCQETCRmt5Z2MXICmWISF+6tZ+ti5OIQEljK
	KHHt3Ad2iISJxP87K1ggEtMZJT7sa4CqamWSmP1jMxtIFa+AlsSWhocsIDaLgKrEza17GEFs
	NgFdiSfv5zKD2KICERJX1sxhhKgXlPgx+R5YvYiAu8S66fNYQYYyC6xlkjiz9gRYkbCAl8SM
	L0uY4W7aO+snE0iCE2hb54Q/YN3MArYSC96vg7LlJTaveQvWICHQySFxZ+I8NoiTBCS+TT7E
	AvG0rMSmA8wQv0lKHFxxg2UCo9gsJEfNQjJ2FpKxCxiZVzGKphYkFxQnpReZ6hUn5haX5qXr
	JefnbmIExvPpf88m7mC8f8D6EKMAB6MSD2/h7voQIdbEsuLK3EOMpkBXTGSWEk3OByaNvJJ4
	Q2MzIwtTE1NjI3NLMyVxXh3pn8FCAumJJanZqakFqUXxRaU5qcWHGJk4OKUaGMWuT9rHpX3x
	fH+2yHZ7w9r9FV6BntkLWM09Td+nrKsJ+p3waOWnPXNrSizO8/JM/z8jw3vxVOeesiaOlNmP
	z3DMuF8faXy8atXVv1pvr1y/XbPsiYPOHWbZhPST8eoHvf+uWp5jcEPTNFzk9/J/DALvXBff
	rJyycfMtz/o/gbt5jxXqPl+wcaISS3FGoqEWc1FxIgBr2dNI4gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFKsWRmVeSWpSXmKPExsVy+t9jQd2CV/UhBm2nzS3+TjrGbnHgzw5G
	i/+PXrNa9C64ymYx5c9yJotNj6+xWlzeNYfNYsb5fUwWty/zWrTuPcJu0bGM0WLVrj+MDjwe
	Lc09bB6/f01i9Ng56y67x6ZVnWwed67tYfPYvKTeo2/LKkaP7dfmMXt83iQXwBnVwGiTkZqY
	klqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA3SxkkJZYk4pUCgg
	sbhYSd8O04TQEDddC5jGCF3fkCC4HiMDNJCwhjFjc8s/poKLvBUH3y5iaWA8x9XFyMkhIWAi
	8f/OChYIW0ziwr31bF2MXBxCAtMZJT7sa4ByWpkkZv/YzAZSxSugJbGl4SFYB4uAqsTNrXsY
	QWw2AV2JJ+/nMoPYogIRElfWzGGEqBeU+DH5Hli9iIC7xLrp81hBhjILrGWSOLP2BFiRsICX
	xIwvS5ghti1llNg76ycTSIITaFvnhD9g3cwCthIL3q+DsuUlNq95yzyBUWAWkiWzkJTNQlK2
	gJF5FaNoakFyQXFSeq6hXnFibnFpXrpecn7uJkZwungmtYNxZYPFIUYBDkYlHt6C3fUhQqyJ
	ZcWVuYcYJTiYlUR4N98ECvGmJFZWpRblxxeV5qQWH2I0BYbBRGYp0eR8YCrLK4k3NDYxNzU2
	tTSxMDGzVBLnvXEzN0RIID2xJDU7NbUgtQimj4mDU6qBsUnjVPFGkZ2rJul5+bLtcpmmxKOx
	LDp/keks/3MZgdNfJRff4pjNNDv5xTLnnAiL6lUavzs/ms48ftTH9XFeJMt2Ka4Jn+rstj5R
	VFp970V+04lti3KPSZz9EfNW/v5WmdNd2Yv166467rZ50amXnX1srv/JKwXv5k16F+dufsXh
	9Lxm7lVVq5RYijMSDbWYi4oTASif1UItAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On Wednesday 03 December 2014 04:13 PM, Arnd Bergmann wrote:
>> Exynos SoCs have Chipid, for identification of product IDs
>> and SoC revisions. This patch intendes to provide initialization
>> code for all these functionalites, at the same time it provides some
>> sysfs entries for accessing these information to userspace.
>>
>> This driver usese existing binding for exnos-chipid.
>
> Nice!

Thanks for review.

>
> On Wednesday 03 December 2014 13:47:37 Pankaj Dubey wrote:
>
>> +       soc_dev_attr->soc_id = exynos_product_id_to_name(soc_product_id);
>> +
>> +       soc_dev = soc_device_register(soc_dev_attr);
>> +       if (IS_ERR(soc_dev))
>> +               goto free_rev;
>> +
>> +       device_create_file(soc_device_to_device(soc_dev), &exynos_product_attr);
>> +       device_create_file(soc_device_to_device(soc_dev),
>> +                               &exynos_main_rev_attr);
>> +       device_create_file(soc_device_to_device(soc_dev), &exynos_sub_rev_attr);
>> +
>
> I don't like the idea of having three extra nonstandard properties here,
> especially when you are not using the machine field for anything useful.
>

I did not get you here. Any suggestions how we can use 'machine' field 
more useful way.

> Also, all three of these just come from the same register, why expose
> them all as the machine and revision standard properties.
>

Agreed. These properties are basically giving same information but with 
small modification.
As you said these are getting exposed via standard properties as well, 
so I have no issue to drop them. Just waiting for more review from 
Samsung folks, will take care of this in next version.


Thanks,
Pankaj Dubey
> 	Arnd
>
