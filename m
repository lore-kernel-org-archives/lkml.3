Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754190Ab3LRNYN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 08:24:13 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:50744 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752165Ab3LRNYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 08:24:11 -0500
X-AuditID: cbfee61a-b7f7e6d000005936-ea-52b1a1f4b5b6
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        linux-ide@vger.kernel.org
Subject: Re: [PATCH 1/2] drivers: ide: Include appropriate header file in
 ide-cd_verbose.c
Date: Wed, 18 Dec 2013 14:23:52 +0100
Message-id: <1930396.DGXdd6ZaUD@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <20131217190610.GJ30592@pd.tnic>
References: <d24d7befadfbfb9501d0e873f13e39fd42ec893b.1387278225.git.rashika.kheria@gmail.com>
 <52B0A93E.7090503@cogentembedded.com> <20131217190610.GJ30592@pd.tnic>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=utf-8
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHLMWRmVeSWpSXmKPExsVy+t9jAd0vCzcGGRw9qW3xecM/Nos551tY
	LP4vyLc4tuMRk8XlXXPYLBYt/s1ucWbVLXYHdo/vrX0sHg+m/mfy2LLyJpPHzll32T1uvbb1
	+LxJLoAtissmJTUnsyy1SN8ugStjyuXP7AUH2CsuPe1nb2B8z9rFyMkhIWAisfXKTiYIW0zi
	wr31bF2MXBxCAosYJeZ0djJBOC1MEi2LN7KAVLEJWElMbF/FCGKLCChJfF00F6yIWeATo8SB
	V6eAEhwcwgIxEvsfFIDUsAioSvw/eJgZxOYV0JQ4t3ASO4gtKuApsWP7SjYQm1NAV2JP21Ko
	ZSsZJXatWcsE0SAo8WPyPbDFzALyEvv2T2UFmc8soC4xZUruBEaBWUiqZiGpmoVQtYCReRWj
	aGpBckFxUnquoV5xYm5xaV66XnJ+7iZGcKg/k9rBuLLB4hCjAAejEg+vh9fGICHWxLLiytxD
	jBIczEoivAtnAIV4UxIrq1KL8uOLSnNSiw8xSnOwKInzHmi1DhQSSE8sSc1OTS1ILYLJMnFw
	SjUw5jxdOuXvwtcswR+vLFZbsJDh23F2F+uJLzovXbr8+HT+rnuble9fjCxYtHbLtvpY/gt3
	UgSPnPy+v3pzzvLZ4hZfMo9ZvM/5d/jcGhOLvviqfXtEjrjUTj1YsyqvsmbygoQPKdu3/q1z
	O2FooRf/8cRTvssSf2LD1aXzmz09epR0rlgtNvSdXqTEUpyRaKjFXFScCAD5fIp5cQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Tuesday, December 17, 2013 08:06:10 PM Borislav Petkov wrote:
> On Tue, Dec 17, 2013 at 10:42:54PM +0300, Sergei Shtylyov wrote:
> > You're right in your doubting: there are quite a lot of drivers used
> > by embedded platforms that nobody has bothered to convert to libata
> > thus far.
> 
> Hold on, what does that mean? IDE is back from the dead and used only
> for embedded stuff?

No, it means that there are legacy PATA chipsets (some used by embedded
platforms) that are only supported by IDE host drivers.

> Or we force people to convert drivers to libata by *deleting* ide?
> 
> :-)

If there is a need I should be able to help in converting these leftover
drivers before we delete IDE.  Once I find some time I will go over all
IDE host drivers, make a list of affected hardware and start a discussion
on IDE removal.

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

