Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752439AbaKJK2I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 05:28:08 -0500
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:52953 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752250AbaKJK2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 05:28:06 -0500
Message-ID: <54609304.4080209@st.com>
Date: Mon, 10 Nov 2014 11:27:16 +0100
From: Maxime Coquelin <maxime.coquelin@st.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>, Peter Griffin <peter.griffin@linaro.org>
Cc: Valentin Rothberg <valentinrothberg@gmail.com>,
        Lee Jones <lee.jones@linaro.org>,
        Srinivas Kandagatla <srinivas.kandagatla@gmail.com>,
        Patrice Chotard <patrice.chotard@st.com>,
        Russell King <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, <kernel@stlinux.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: ARM: sti: SOC_STIH407 and STIH407_RESET?
References: <1415614934.4862.22.camel@x220>
In-Reply-To: <1415614934.4862.22.camel@x220>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.251.17.209]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.28,0.0.0000
 definitions=2014-11-10_01:2014-11-07,2014-11-09,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,
On 11/10/2014 11:22 AM, Paul Bolle wrote:
> Your commit c27321141915 ("ARM: sti: Add STiH407 Kconfig entry to select
> STIH407_RESET") was included in today's linux-next (ie, next-20141110).
> It adds a Kconfig entry for SOC_STIH407. That entry selects
> STIH407_RESET.
>
> There's no Kconfig symbol STIH407_RESET. And there's nothing in
> next-20141110 that cares about SOC_STIH407. So this entry is currently a
> nop.
>
> I assume that there are one or more patches queued that make this entry
> do something. Is that correct?
Exactly.

The STIH407_RESET symbol is introduced in Reset sub-system.

The STiH407 reset has been merged in Philipp Zabel Reset tree for v3.19:
http://git.pengutronix.de/?p=pza/linux.git;a=shortlog;h=refs/heads/reset/for_v3.19

Commit: 3ba9204308eb51fe98fb1ab352c17d5319f26724

Best regards,
Maxime

>
>
> Paul Bolle
>

