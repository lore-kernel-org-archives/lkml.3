Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932299AbaAaMfG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 07:35:06 -0500
Received: from eu1sys200aog108.obsmtp.com ([207.126.144.125]:44131 "EHLO
	eu1sys200aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754142AbaAaMfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 07:35:04 -0500
Message-ID: <52EB96BB.6070800@st.com>
Date: Fri, 31 Jan 2014 12:27:39 +0000
From: srinivas kandagatla <srinivas.kandagatla@st.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>
Cc: <devicetree@vger.kernel.org>, Russell King <linux@arm.linux.org.uk>,
        <kernel@stlinux.com>, Linus Walleij <linus.walleij@linaro.org>,
        Patrice CHOTARD <patrice.chotard@st.com>,
        <linux-kernel@vger.kernel.org>, Stuart Menefy <stuart.menefy@st.com>,
        Rob Herring <robh+dt@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>, <maxime.coquelin@st.com>,
        <alexandre.torgue@st.com>
Subject: Re: [PATCH 1/4] ARM: STi: add stid127 soc support
References: <1391093744-19905-1-git-send-email-patrice.chotard@st.com> <1391093744-19905-2-git-send-email-patrice.chotard@st.com> <201401301935.16463.arnd@arndb.de> <201401301939.08302.arnd@arndb.de>
In-Reply-To: <201401301939.08302.arnd@arndb.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.65.51.147]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,
On 30/01/14 18:39, Arnd Bergmann wrote:
> Actually reading the code in this file shows that the L2 cache
> initialization is the only nonstandard thing in there. We should
> really find a way to get rid of the entire function.
I think this will get rid of lot of code left in board-dt.

> 
> Sorry if I missed the initial review, but can you explain
> why this is needed to start with?
On ST SoCs the default value for L2 AUX_CTRL register is 0x0, so we  set
the way-size explicit here.

Thanks,
srini
