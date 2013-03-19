Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757961Ab3CSJpP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 05:45:15 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:43279 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754561Ab3CSJpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 05:45:12 -0400
X-AuditID: cbfee68f-b7f4a6d000001436-67-514833a5636a
Message-id: <514833A6.5010502@samsung.com>
Date: Tue, 19 Mar 2013 18:45:10 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'MyungJoo Ham'" <myungjoo.ham@samsung.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] extcon: max8997: add missing const
References: <000101ce2462$e31b5fa0$a9521ee0$%han@samsung.com>
 <000201ce2463$06750e60$135f2b20$%han@samsung.com>
In-reply-to: <000201ce2463$06750e60$135f2b20$%han@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDIsWRmVeSWpSXmKPExsVy+t8zLd2lxh6BBqfPalhcXniJ1eLyrjls
	FrcbV7A5MHv0bVnF6PF5k1wAUxSXTUpqTmZZapG+XQJXxvSHM5kKvvNVLLnWyNrA2MPTxcjJ
	ISFgIvHoXjsjhC0mceHeerYuRi4OIYFljBL3t5xghylauXAjC0RiOqPEjWvToapeMErs6TwI
	1s4roCXRvuwGC4jNIqAq8aPvODOIzQYU3//iBhuILSoQJrFy+hUWiHpBiR+T74HZIgIqEp/X
	HwerYRbwltgxcQIriC0sYCdxYeIasDlCAoUS/ZNugtVzAsVXH9rGAlGvI7G/dRpUr7zE5jVv
	mUGOkxCYzC6xpGM1O8RBAhLfJh8CauAASshKbDrADPGZpMTBFTdYJjCKzUJy0iwkY2chGbuA
	kXkVo2hqQXJBcVJ6kbFecWJucWleul5yfu4mRkjM9O9gvHvA+hBjMtDKicxSosn5wJjLK4k3
	NDYzsjA1MTU2Mrc0I01YSZxXrcU6UEggPbEkNTs1tSC1KL6oNCe1+BAjEwenVAPj0kerHP/J
	MFcEONid2bNugt72JoUa3tPtnLUf+I23fm5hvdy5ZMG9jalJW+snm4ZcT7HZ6/W4QXbzJuEZ
	5z7+LFt5kit549uCgw2K9xvZy7SiO8/9vXtfYlr/vkTh2ic//FV9j1udSK2wvMQ687LOxq+a
	FsJnH1Ut3iL+Y/fNdXHxotsEf9X8VGIpzkg01GIuKk4EAKS5r32vAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJIsWRmVeSWpSXmKPExsVy+t9jQd2lxh6BBgc7lS0uL7zEanF51xw2
	i9uNK9gcmD36tqxi9Pi8SS6AKaqB0SYjNTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJc
	SSEvMTfVVsnFJ0DXLTMHaImSQlliTilQKCCxuFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCO
	MWP6w5lMBd/5KpZca2RtYOzh6WLk5JAQMJFYuXAjC4QtJnHh3nq2LkYuDiGB6YwSN65Nh3Je
	MErs6TzICFLFK6Al0b7sBlgHi4CqxI++48wgNhtQfP+LG2wgtqhAmMTK6VdYIOoFJX5Mvgdm
	iwioSHxefxyshlnAW2LHxAmsILawgJ3EhYlrwOYICRRK9E+6CVbPCRRffWgbC0S9jsT+1mlQ
	vfISm9e8ZZ7AKDALyYpZSMpmISlbwMi8ilE0tSC5oDgpPddIrzgxt7g0L10vOT93EyM4Ip9J
	72Bc1WBxiFGAg1GJh1chzD1QiDWxrLgy9xCjBAezkgjvKn2PQCHelMTKqtSi/Pii0pzU4kOM
	ycAQmMgsJZqcD0wWeSXxhsYmZkaWRmbGJubGxqQJK4nzHmy1DhQSSE8sSc1OTS1ILYLZwsTB
	KdXAmOsaGDg9u/fo5dlvvRwfCe9U9QtgcNp9Pj1q67MIrqa71oYu9RIu/Fy9VxWYhASDH+7g
	sHXbZPku9eTV+Ec/zho9F5Y8nB1/MLnRPOZReP7y5L7ovdr3Nzk3v3jeuHRu/JPDeZOSTzxf
	6n/9yYMQ/pbYHbfKVjOWne213b/qhL4B14SGk6+dlFiKMxINtZiLihMBhE9A+AwDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19/2013 02:31 PM, Jingoo Han wrote:
> Fixed the checkpatch warning as below:
>
>   WARNING: static const char * array should probably be static const char * const
>   #163: FILE: drivers/extcon/extcon-max8997.c:163:
>   +static const char *max8997_extcon_cable[] = {
>
> Also, const is added to variable 'supported_cable' to prevent
> build warning as below:
>
>   drivers/extcon/extcon-max8997.c: In function 'max8997_muic_probe':
>   drivers/extcon/extcon-max8997.c:708:30: warning: assignment discards 'const' qualifier from pointer target type [enabled by
> default]
>
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
> Changes since v1:
> - Added const to variable 'supported_cable'
>
>  drivers/extcon/extcon-max8997.c |    2 +-
>  include/linux/extcon.h          |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/extcon/extcon-max8997.c b/drivers/extcon/extcon-max8997.c
> index 20772ad..b82a591 100644
> --- a/drivers/extcon/extcon-max8997.c
> +++ b/drivers/extcon/extcon-max8997.c
> @@ -160,7 +160,7 @@ enum {
>  	_EXTCON_CABLE_NUM,
>  };
>  
> -static const char *max8997_extcon_cable[] = {
> +static const char * const max8997_extcon_cable[] = {
OK.
>  	[EXTCON_CABLE_USB]			= "USB",
>  	[EXTCON_CABLE_USB_HOST]			= "USB-Host",
>  	[EXTCON_CABLE_TA]			= "TA",
> diff --git a/include/linux/extcon.h b/include/linux/extcon.h
> index fcb51c8..741a491 100644
> --- a/include/linux/extcon.h
> +++ b/include/linux/extcon.h
> @@ -113,7 +113,7 @@ struct extcon_cable;
>  struct extcon_dev {
>  	/* --- Optional user initializing data --- */
>  	const char	*name;
> -	const char **supported_cable;
> +	const char * const *supported_cable;
I understand your intention to fix build warning.
But, I don't agree this coding style. I think this coding
style is not general method.

Thanks,
Chanwoo Choi




