Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753794AbaKRIyc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 03:54:32 -0500
Received: from mout.kundenserver.de ([212.227.126.131]:52301 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145AbaKRIya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 03:54:30 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Maxime Coquelin <maxime.coquelin@st.com>
Cc: Peter Griffin <peter.griffin@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        srinivas.kandagatla@gmail.com, patrice.chotard@st.com,
        lee.jones@linaro.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v3 00/11] Add stih410 SoC/board and USB2/1.1 support for stih416
Date: Tue, 18 Nov 2014 09:53:55 +0100
Message-ID: <1795476.NaojQ17vPi@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <546B07BD.4030400@st.com>
References: <1416242884-5261-1-git-send-email-peter.griffin@linaro.org> <546B07BD.4030400@st.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:3wfQW29S4TK0SH+Udnph1g8McCfOWOQl84nPKZnXfrk
 n++jY8W+E0DAdbVlpoBY85DZuhnYCB+xuuG4Grs8V25U3kw4By
 GJ6QG9n69VdH17T5IVHg9t544IWmf81Q87EkniPnNy/Wa+qJOu
 EjXmfOaWj/dahFdp6NiTEQWfNjFhr+YmuxKEabesy0hmewSNwA
 eDDIyzgH6prFCnmzBRDgWl2geu0s0ZAYYBdPrDxDq46e3jSD0z
 Ro7LIV0ZaTJM2jScZwd8lg7y3GeCygmx4pmoCj4rDverdy4aF0
 G2yWLv/Z7OTEqMRcdbp7ikKMlU9yTmehfVMqWFfgC8Tft/OrUK
 YLViTil5xXBbIg2tfTmw=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 18 November 2014 09:47:57 Maxime Coquelin wrote:
> 
> For the series,
> 
>      Acked-by: Maxime Coquelin <maxime.coquelin@st.com>
> 
>      If Arnd is fine with the series, these patches will be part of my 
> next pull request.

Yes, it's all good. Just keep the defconfig change separate from the
DT changes, as usual.

	Arnd
