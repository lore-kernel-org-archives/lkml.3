Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755396Ab3IZBRJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 21:17:09 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:31560 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754831Ab3IZBRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 21:17:07 -0400
X-AuditID: cbfee68d-b7fe86d0000077a5-fc-52438b11b8a2
From: Jingoo Han <jg1.han@samsung.com>
To: "'Sachin Kamat'" <sachin.kamat@linaro.org>
Cc: "'Mark Brown'" <broonie@kernel.org>,
        "'Liam Girdwood'" <lgirdwood@gmail.com>,
        "'LKML'" <linux-kernel@vger.kernel.org>,
        "'Marek Szyprowski'" <m.szyprowski@samsung.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <000901ceb9c3$97fe74c0$c7fb5e40$%han@samsung.com>
 <001201ceb9c5$95268ab0$bf73a010$%han@samsung.com>
 <CAK9yfHxu3LxaKVSX9WO6J7dd+xtGWF4304pUHwN=oFd_hwy3hQ@mail.gmail.com>
In-reply-to: <CAK9yfHxu3LxaKVSX9WO6J7dd+xtGWF4304pUHwN=oFd_hwy3hQ@mail.gmail.com>
Subject: Re: [PATCH 09/20] regulator: lp3972: use devm_regulator_register()
Date: Thu, 26 Sep 2013 10:17:04 +0900
Message-id: <000201ceba56$1ce708e0$56b51aa0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac652HUo2cif4vmhQsyMZ3u+NLuSvQAfSHLg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPIsWRmVeSWpSXmKPExsVy+t8zQ13Bbucgg3NvTCymPnzCZnF54SVW
	i29XOpgsLu+aw2ax9shddouTf3oZHdg8ds66y+6xaVUnm8eda3vYPPq2rGL0+LxJLoA1issm
	JTUnsyy1SN8ugStjz7nHTAWNbBXnTjYwNTAeYeli5OSQEDCRePn3FxOELSZx4d56ti5GLg4h
	gWWMEi+vrYQr+rbgGDNEYhGjxPNXcxghnF+MEr33L7KDVLEJqEl8+XIYzBYR0JFYsWstE0gR
	s8AZRol7G/ug5u5glDh77xnYQk6BYImbHy4xgtjCAt4SJ/uOsYLYLAKqEgsPbWQGsXkFbCXu
	7pnABGELSvyYfA/sJmYBLYn1O48zQdjyEpvXvAWq5wC6VV3i0V9diCOMJDadmMIOUSIise/F
	O7CrJQReskuc37ifBWKXgMS3yYdYIHplJTYdYIZ4WVLi4IobLBMYJWYh2TwLyeZZSDbPQrJi
	ASPLKkbR1ILkguKk9CJDveLE3OLSvHS95PzcTYyQyO3dwXj7gPUhxmSg9ROZpUST84GRn1cS
	b2hsZmRhamJqbGRuaUaasJI4r1qLdaCQQHpiSWp2ampBalF8UWlOavEhRiYOTqkGRsVlOjW3
	yp+8/xH76zxH3ju3dVXnp7xfHRqvZVHzwzY879XuKVdl75wQOCZkWdLknap581ukvN5XdkXD
	Ffs8RNn2hNtwuE2p3K3582nGzKgt6iKOCS3qEVfLrx5wv/auVf20fQWfao2cF+PdM6s3iC53
	ztV4GSRxL88ySzs59PrUu7vkJ1mcUWIpzkg01GIuKk4EAKHMIjbyAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDKsWRmVeSWpSXmKPExsVy+t9jAV3Bbucgg3n/DSymPnzCZnF54SVW
	i29XOpgsLu+aw2ax9shddouTf3oZHdg8ds66y+6xaVUnm8eda3vYPPq2rGL0+LxJLoA1qoHR
	JiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwfoBCWFssSc
	UqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jxp5zj5kKGtkqzp1sYGpgPMLSxcjJ
	ISFgIvFtwTFmCFtM4sK99WxdjFwcQgKLGCWev5rDCOH8YpTovX+RHaSKTUBN4suXw2C2iICO
	xIpda5lAipgFzjBK3NvYB9W+g1Hi7L1nTCBVnALBEjc/XGIEsYUFvCVO9h1jBbFZBFQlFh7a
	CLabV8BW4u6eCUwQtqDEj8n3wO5jFtCSWL/zOBOELS+xec1boHoOoFvVJR791YU4wkhi04kp
	7BAlIhL7XrxjnMAoNAvJpFlIJs1CMmkWkpYFjCyrGEVTC5ILipPScw31ihNzi0vz0vWS83M3
	MYLTwjOpHYwrGywOMQpwMCrx8F5gdg4SYk0sK67MPcQowcGsJML7zQgoxJuSWFmVWpQfX1Sa
	k1p8iDEZ6NGJzFKiyfnAlJVXEm9obGJmZGlkZmFkYm5OmrCSOO+BVutAIYH0xJLU7NTUgtQi
	mC1MHJxSDYzebn48ZW9uW9pqZUpfvHVk28q2eTuEGkJ8l20vsp4RtyH8HL/9V9Fbm57tSTm9
	xUGlK2bjG7PaFSuiYz5OSS/JSjmfyripRcjKguFM1BnHv4maeu+bulmXbN73JUmm5fBlrQuF
	O3/5nt9w8M6XG4vu9rUelc54nMS3hotnsbL9zocsES+aJC4psRRnJBpqMRcVJwIAED6/3E8D	AAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, September 25, 2013 7:18 PM, Sachin Kamat wrote:
> On 25 September 2013 13:32, Jingoo Han <jg1.han@samsung.com> wrote:
> > Use devm_regulator_register() to make cleanup paths simpler.
> 
> >  static int lp3972_i2c_remove(struct i2c_client *i2c)
> >  {
> >         struct lp3972 *lp3972 = i2c_get_clientdata(i2c);
> > -       int i;
> >
> > -       for (i = 0; i < lp3972->num_regulators; i++)
> > -               regulator_unregister(lp3972->rdev[i]);
> >         kfree(lp3972->rdev);
> 
> With devm the unregister would happen after the freeing of the device.
> Wouldn't this re-ordering cause any
> problems?

It seems to make the problem.
I will remove this patch from next V2 patch series.
Thank you.

Best regards,
Jingoo Han

