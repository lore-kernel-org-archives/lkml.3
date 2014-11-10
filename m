Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752447AbaKJKki (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 05:40:38 -0500
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:49658 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751977AbaKJKkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 05:40:36 -0500
Message-ID: <546095EC.2040501@st.com>
Date: Mon, 10 Nov 2014 11:39:40 +0100
From: Maxime Coquelin <maxime.coquelin@st.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>, Kishon Vijay Abraham I <kishon@ti.com>
Cc: Gabriel FERNANDEZ <gabriel.fernandez@st.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@gmail.com>,
        Patrice Chotard <patrice.chotard@st.com>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <kernel@stlinux.com>, Gabriel Fernandez <gabriel.fernandez@linaro.org>
Subject: Re: [PATCH v5 2/8] phy: miphy28lp: Add PHY header file for DT x Driver
 defines
References: <1415098284-11182-1-git-send-email-gabriel.fernandez@linaro.org> <1415098284-11182-3-git-send-email-gabriel.fernandez@linaro.org> <545B1C53.9010406@ti.com> <545B3FA4.8040109@st.com> <20141106112825.GC26543@x1> <545B6144.2020503@st.com> <20141106153659.GD26543@x1> <545B9F15.5070404@st.com> <20141107130538.GB3745@x1>
In-Reply-To: <20141107130538.GB3745@x1>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.251.17.209]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.28,0.0.0000
 definitions=2014-11-10_01:2014-11-07,2014-11-09,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 11/07/2014 02:05 PM, Lee Jones wrote:

<snip>
> If the merge turns out to be simple, then Git will do the correct
> thing; however, if the first version of the patch is applied, then
> some changes around the same area of the file occur _then_ when the
> second version (of the same patch differing only by SHA1) is applied
> Git will get confused.  If it has the same SHA1 however, Git will
> discard it as 'already applied'.  This is the reason we pass around
> shared tags to immutable branches.
Looking at how the patch is trivial, I persist to think there is no issue.
But OK, I will prepare an immutable branch..

Kishon, checkpatch complains because this new file has no maintainer.
Is it ok for you if I add it to the Generic PHY subsystem?

Regards,
Maxime

