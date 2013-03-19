Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933503Ab3CSJgc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 05:36:32 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:41735 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754421Ab3CSJgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 05:36:17 -0400
X-AuditID: cbfee68e-b7f946d000001e37-3f-514831838cb7
Message-id: <51483184.6070009@samsung.com>
Date: Tue, 19 Mar 2013 18:36:04 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'MyungJoo Ham'" <myungjoo.ham@samsung.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] extcon: max8997: use dev_err() instead of pr_err()
References: <000101ce2462$e31b5fa0$a9521ee0$%han@samsung.com>
In-reply-to: <000101ce2462$e31b5fa0$a9521ee0$%han@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphkeLIzCtJLcpLzFFi42I5/e+Znm6LoUegweTnjBaXd81hc2D0+LxJ
	LoAxissmJTUnsyy1SN8ugSvj3dZe1oKLbBUbWm4yNzDuZu1i5OSQEDCRWHezjRHCFpO4cG89
	WxcjF4eQwDJGiS2Lt7DBFE3cd4EZIrGIUeJK+0UWCKeTSWLHmu3sIFW8AloSMz61MoHYLAKq
	EhcXHWAGsdmA4vtf3ACbJCoQJrFy+hUWiHpBiR+T74HZIgIqEp/XHwerYRbwltgxcQLQeRwc
	wgJ+EjMWeYCEhQRsJY58WAk2klPATmLizrNMEOU6Evtbp0G1yktsXvMW7FAJgWZ2iRNNL9gg
	7hGQ+Db5EAvITAkBWYlNEKdJCEhKHFxxg2UCo9gsJBfNQjJ2FpKxCxiZVzGKphYkFxQnpRcZ
	6RUn5haX5qXrJefnbmKExETfDsabB6wPMSYDrZzILCWanA+MqbySeENjMyMLUxNTYyNzSzPS
	hJXEedVarAOFBNITS1KzU1MLUovii0pzUosPMTJxcEo1MMoqLDLyubHdUNVkz4Ilubdj8sMt
	vz4/onz2zMJNpcebQn8XL57+bs63gHf/PBxvKF79fn6OUWcPl94x+b0Pr1owrVv1Wr6/q/Hj
	JvkJq3N4HBIWT932ie31pZNM28XDZTkXMPtZPGX826B4UGvvogUuaw3atcwKHl2+qNGjwMwu
	WPjE8+yWs+uUWIozEg21mIuKEwGTzBCUnwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJIsWRmVeSWpSXmKPExsVy+t9jAd1mQ49Ag8kLLCwu75rD5sDo8XmT
	XABjVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7Q
	VCWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jxrutvawFF9kqNrTcZG5g
	3M3axcjJISFgIjFx3wVmCFtM4sK99WxdjFwcQgKLGCWutF9kgXA6mSR2rNnODlLFK6AlMeNT
	KxOIzSKgKnFx0QGwbjag+P4XN9hAbFGBMImV06+wQNQLSvyYfA/MFhFQkfi8/jhYDbOAt8SO
	iROAruDgEBbwk5ixyAMkLCRgK3Hkw0qwkZwCdhITd55lgijXkdjfOg2qVV5i85q3zBMYBWYh
	2TALSdksJGULGJlXMYqmFiQXFCel5xrqFSfmFpfmpesl5+duYgRH3DOpHYwrGywOMQpwMCrx
	8J4Idg8UYk0sK67MPcQowcGsJMK7St8jUIg3JbGyKrUoP76oNCe1+BBjMjAAJjJLiSbnA5NB
	Xkm8obGJmZGlkZmxibmxMWnCSuK8B1qtA4UE0hNLUrNTUwtSi2C2MHFwSjUwrjzScPnVyojD
	v3hP98wrivZjOWiYpWZ2z/tHZfBe91Vycenflkh56P5m7phf3LejaKHc/jTZJR9u/s2ZeuNm
	TX1PpaRd2JM5Lx6nznPuzIu2aKq+e9/uxVsRdz7fFqXHV5oXLEtR7TbI/+wVlMTS96s9fm9/
	o6NozvsqF/fMQCcnubg/huxKLMUZiYZazEXFiQB3Dz14/AIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19/2013 02:30 PM, Jingoo Han wrote:
> dev_err() is more preferred than pr_err().
>
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
> No Changes since v1:
>
>  drivers/extcon/extcon-max8997.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/extcon/extcon-max8997.c b/drivers/extcon/extcon-max8997.c
> index 69641bc..20772ad 100644
> --- a/drivers/extcon/extcon-max8997.c
> +++ b/drivers/extcon/extcon-max8997.c
> @@ -646,7 +646,7 @@ static void max8997_muic_detect_cable_wq(struct work_struct *work)
>  
>  	ret = max8997_muic_detect_dev(info);
>  	if (ret < 0)
> -		pr_err("failed to detect cable type\n");
> +		dev_err(info->dev, "failed to detect cable type\n");
>  }
>  
>  static int max8997_muic_probe(struct platform_device *pdev)
Applied it. Thanks.

Chanwoo Choi
