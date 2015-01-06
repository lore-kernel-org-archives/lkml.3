Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754305AbbAFE5v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 23:57:51 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:36068 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752933AbbAFE5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 23:57:49 -0500
X-AuditID: cbfee68d-f79296d000004278-ee-54ab6b4bc868
Message-id: <54AB6B4A.2010802@samsung.com>
Date: Tue, 06 Jan 2015 13:57:46 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] extcon: max77693: Constify struct regmap_config
References: <1420448247-8097-1-git-send-email-k.kozlowski@samsung.com>
In-reply-to: <1420448247-8097-1-git-send-email-k.kozlowski@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDLMWRmVeSWpSXmKPExsWyRsSkQNc7e3WIwYIr7BavXxhaXN41h83i
	duMKNgdmj74tqxg9Pm+SC2CK4rJJSc3JLEst0rdL4Mp4s6+bvWASe0XrlJfsDYxfWLsYOTkk
	BEwkPu9vgbLFJC7cW88GYgsJLGWUWDjDAqam43YXcxcjF1B8EaNE84UdbBDOa0aJ7V/eAzkc
	HLwCWhJrLkSANLAIqEpMv3KWBcRmAwrvf3EDbKioQJjEyulXwOK8AoISPybfA7NFBAwlDu7e
	zgRiMwt4SvTNaAerFxZwkXi0dB0zyHghATeJRZviQMKcAu4SL9beYIUo15HY3zqNDcKWl9i8
	5i0zxM3T2SX6v2RDnCMg8W3yIRaQMRICshKbDkCVSEocXHGDZQKj2CwkB81CMnUWkqkLGJlX
	MYqmFiQXFCelFxnqFSfmFpfmpesl5+duYgRGyul/z3p3MN4+YH2IUYCDUYmH1+PEyhAh1sSy
	4srcQ4ymQFdMZJYSTc4HxmNeSbyhsZmRhamJqbGRuaWZkjivotTPYCGB9MSS1OzU1ILUovii
	0pzU4kOMTBycUg2MlzUPtiWzG7z69OrB+qx7FdbHv5za9fPL90dbli8/OmVO3Z2dMSlW21t3
	r6iZUb5t1obnQdWRG/Z7/+7JNguWPPTtQFgz35t809vc0ruydSyd5kmar/s5KWpZ5dLL+W7c
	Z967bF0sXdZt/f/YtGhv31Un9ysx7p2pKcN+ylvL7G+74793k+52XlBiKc5INNRiLipOBAA0
	JccbjwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOIsWRmVeSWpSXmKPExsVy+t9jAV3v7NUhBgvrLF6/MLS4vGsOm8Xt
	xhVsDswefVtWMXp83iQXwBTVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQ
	l5ibaqvk4hOg65aZA7RCSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYw5jx
	Zl83e8Ek9orWKS/ZGxi/sHYxcnJICJhIdNzuYoawxSQu3FvP1sXIxSEksIhRovnCDijnNaPE
	9i/vgRwODl4BLYk1FyJAGlgEVCWmXznLAmKzAYX3v7jBBmKLCoRJrJx+BSzOKyAo8WPyPTBb
	RMBQ4uDu7UwgNrOAp0TfjHawemEBF4lHS9cxg4wXEnCTWLQpDiTMKeAu8WLtDVaIch2J/a3T
	2CBseYnNa94yT2AUmIVkwywkZbOQlC1gZF7FKJpakFxQnJSea6RXnJhbXJqXrpecn7uJERyJ
	z6R3MK5qsDjEKMDBqMTD63FiZYgQa2JZcWXuIUYJDmYlEd4dn1eFCPGmJFZWpRblxxeV5qQW
	H2I0BQbARGYp0eR8YJLIK4k3NDYxM7I0Mje0MDI2VxLnVbJvCxESSE8sSc1OTS1ILYLpY+Lg
	lGpgnKd6fKnQv7grvmcNrR8flm1K/rZf++3s2avNrmT/sU7k3PjTmDPm+fqXN/sXZrlvXvs+
	KM/ht4LKtDtCR/ytbWYY7xbdc2RZ35rHzar6v//rxrStm+R7Uv3JwTZ9Zs9F+bsathmIm838
	GsSumNR2NG75G1HRxAkbmviLVx8unVhQffPTvY9P9ymxFGckGmoxFxUnAgDMtp432gIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/05/2015 05:57 PM, Krzysztof Kozlowski wrote:
> The regmap_config struct may be const because it is not modified by the
> driver and regmap_init() accepts pointer to const.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> ---
>  drivers/extcon/extcon-max77693.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/extcon/extcon-max77693.c b/drivers/extcon/extcon-max77693.c
> index 740a14d35072..af165fd0c6f5 100644
> --- a/drivers/extcon/extcon-max77693.c
> +++ b/drivers/extcon/extcon-max77693.c
> @@ -1033,7 +1033,7 @@ static irqreturn_t max77693_muic_irq_handler(int irq, void *data)
>  	return IRQ_HANDLED;
>  }
>  
> -static struct regmap_config max77693_muic_regmap_config = {
> +static const struct regmap_config max77693_muic_regmap_config = {
>  	.reg_bits = 8,
>  	.val_bits = 8,
>  };
> 

Applied.

Thanks,
Chanwoo Choi
