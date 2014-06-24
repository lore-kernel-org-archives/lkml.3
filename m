Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753663AbaFXKvG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 06:51:06 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:28137 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752751AbaFXKvE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 06:51:04 -0400
X-AuditID: cbfee690-b7fb56d000003439-11-53a958156a6b
From: Jingoo Han <jg1.han@samsung.com>
To: "=?UTF-8?Q?'Antoine_T=C3=A9nart'?=" 
	<antoine.tenart@free-electrons.com>
Cc: sebastian.hesselbarth@gmail.com, Peter.Chen@freescale.com,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1403606121-6368-1-git-send-email-antoine.tenart@free-electrons.com>
 <1403606121-6368-8-git-send-email-antoine.tenart@free-electrons.com>
In-reply-to: <1403606121-6368-8-git-send-email-antoine.tenart@free-electrons.com>
Subject: Re: [PATCH v2 07/12] usb: chipidea: add a generic driver
Date: Tue, 24 Jun 2014 19:51:01 +0900
Message-id: <000001cf8f9a$3045f3a0$90d1dae0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac+PmFpPVoVNAGgfQKGeiDCB5rIQ/wAALc0g
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgleLIzCtJLcpLzFFi42I5/e+Zoa5oxMpgg1MdBhYd1xYzWexY8Z/V
	4vLCS6wW747vZrHY9PgakLtrDpvFomWtzBbHZv9lsnj/09Hi6YMmJovvH2eyOnB7PNl0kdHj
	3+F+Jo+ds+6ye2xeUu8xeeFFZo++LasYPT5vkgtgj+KySUnNySxLLdK3S+DKeLLzLFvBde6K
	cz3n2BoYH3F2MXJySAiYSBz5/ZgJwhaTuHBvPVsXIxeHkMAyRokrC3+ywhQdvL2eFSIxnVHi
	2ux5LBDOb0aJ503HmEGq2ATUJL58OcwOYosIeErcOH6AGaSIWWAXk8TZL5MZITpmMkq0rH7G
	CFLFKRAs0TZ5EZgtLOAoMfvsFrBuFgFVibvzmsBsXgFbiTv3dzJD2IISPybfYwGxmQXUJSbN
	W8QMYWtLPHl3Aeg+DqBb1SUe/dWFOMJI4uvs86wQJSIS+168A7tBQmAqh8TqN+8ZIXYJSHyb
	fIgFoldWYtMBZoiXJSUOrrjBMoFRYhaSzbOQbJ6FZPMsJCsWMLKsYhRNLUguKE5KLzLRK07M
	LS7NS9dLzs/dxAiJ/Qk7GO8dsD7EmAy0fiKzlGhyPjB15JXEGxqbGVmYmpgaG5lbmpEmrCTO
	q/YoKUhIID2xJDU7NbUgtSi+qDQntfgQIxMHp1QDo9u8XTlPL5Q+6ubllTEPKe8S1mNY5B9b
	s2F+xt5TD35ei+6/8GMXq1i9X+m9/qVqrSu/WQesqHwcMqvt4fFr1/SiNr8pvK69rNhg/5+5
	ykcdtldVsNbd5WGU/3UwUNttduLNZ1nKbGzTN7jMOT/V5kkR5/sFTKG+X/9o+zk1e1rMmMK9
	9qTwUiWW4oxEQy3mouJEAGfKcc8TAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPKsWRmVeSWpSXmKPExsVy+t9jQV3RiJXBBhNualt0XFvMZLFjxX9W
	i8sLL7FavDu+m8Vi0+NrQO6uOWwWi5a1Mlscm/2XyeL9T0eLpw+amCy+f5zJ6sDt8WTTRUaP
	f4f7mTx2zrrL7rF5Sb3H5IUXmT36tqxi9Pi8SS6APaqB0SYjNTEltUghNS85PyUzL91WyTs4
	3jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMH6EYlhbLEnFKgUEBicbGSvh2mCaEhbroWMI0R
	ur4hQXA9RgZoIGEdY8aTnWfZCq5zV5zrOcfWwPiIs4uRk0NCwETi4O31rBC2mMSFe+vZuhi5
	OIQEpjNKXJs9jwXC+c0o8bzpGDNIFZuAmsSXL4fZQWwRAU+JG8cPMIMUMQvsYpI4+2UyI0TH
	TEaJltXPGEGqOAWCJdomLwKzhQUcJWaf3QLWzSKgKnF3XhOYzStgK3Hn/k5mCFtQ4sfkeywg
	NrOAusSkeYuYIWxtiSfvLgDdygF0q7rEo7+6EEcYSXydfZ4VokREYt+Ld4wTGIVmIZk0C8mk
	WUgmzULSsoCRZRWjaGpBckFxUnquoV5xYm5xaV66XnJ+7iZGcGJ5JrWDcWWDxSFGAQ5GJR5e
	Bv8VwUKsiWXFlbmHGCU4mJVEeKtsVwYL8aYkVlalFuXHF5XmpBYfYjQFenQis5Rocj4w6eWV
	xBsam5gZWRqZWRiZmJsrifMeaLUOFBJITyxJzU5NLUgtgulj4uCUamD0Djsm4KCstafUxOSw
	Upuxm4HrlZ2uYksOmjj+8rfKc/KM8eCddnptjZiOtEzX1C1LLs87VHpIsbSobfm7r5qrC1ZE
	Ft1Onj3RaP2O1iKdN2qR07uzmBSzo8+VXNN5NPO2jfkeoz1z5gWserm8nj+k9/UXjasfuMsT
	jj77Vn/kpfQGpcscNQxKLMUZiYZazEXFiQAIDHKrQgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, June 24, 2014 7:35 PM, Antoine Tenart wrote:
> 
> Add a generic ChipIdea driver, with optional PHY and clock, to support
> ChipIdea controllers that doesn't need specific functions.

s/doesn't/don't

> 
> Needed for the Marvell Berlin SoCs SUB controllers.

s/SUB/USB

> Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
> ---
>  drivers/usb/chipidea/Makefile          |   1 +
>  drivers/usb/chipidea/ci_hdrc_generic.c | 108 +++++++++++++++++++++++++++++++++
>  2 files changed, 109 insertions(+)
>  create mode 100644 drivers/usb/chipidea/ci_hdrc_generic.c
> 
> diff --git a/drivers/usb/chipidea/Makefile b/drivers/usb/chipidea/Makefile
> index 2f099c7df7b5..c705f0fe7a00 100644
> --- a/drivers/usb/chipidea/Makefile
> +++ b/drivers/usb/chipidea/Makefile
> @@ -20,4 +20,5 @@ endif
> 
>  ifneq ($(CONFIG_OF),)
>  	obj-$(CONFIG_USB_CHIPIDEA)	+= usbmisc_imx.o ci_hdrc_imx.o
> +	obj-$(CONFIG_USB_CHIPIDEA)	+= ci_hdrc_generic.o
>  endif
> diff --git a/drivers/usb/chipidea/ci_hdrc_generic.c b/drivers/usb/chipidea/ci_hdrc_generic.c
> new file mode 100644
> index 000000000000..27520710a1f7
> --- /dev/null
> +++ b/drivers/usb/chipidea/ci_hdrc_generic.c

[...]

> +
> +MODULE_DESCRIPTION("Generic ChipIdea HDRC USB binding");
> +MODULE_AUTHOR("Antoine Ténart <antoine.tenart@free-electrons.com>");
> +MODULE_LICENSE("GPL");

How about "GPL v2"?

Best regards,
Jingoo Han

> --
> 1.9.1


