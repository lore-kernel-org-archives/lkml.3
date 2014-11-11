Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753508AbaKKKrt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 05:47:49 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:47179 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753243AbaKKKrq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 05:47:46 -0500
Message-ID: <5461E914.30906@ti.com>
Date: Tue, 11 Nov 2014 16:16:44 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Maxime Coquelin <maxime.coquelin@st.com>, Lee Jones <lee.jones@linaro.org>
CC: Gabriel FERNANDEZ <gabriel.fernandez@st.com>,
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
References: <1415098284-11182-1-git-send-email-gabriel.fernandez@linaro.org> <1415098284-11182-3-git-send-email-gabriel.fernandez@linaro.org> <545B1C53.9010406@ti.com> <545B3FA4.8040109@st.com> <20141106112825.GC26543@x1> <545B6144.2020503@st.com> <20141106153659.GD26543@x1> <545B9F15.5070404@st.com> <20141107130538.GB3745@x1> <546095EC.2040501@st.com>
In-Reply-To: <546095EC.2040501@st.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Monday 10 November 2014 04:09 PM, Maxime Coquelin wrote:
> 
> On 11/07/2014 02:05 PM, Lee Jones wrote:
> 
> <snip>
>> If the merge turns out to be simple, then Git will do the correct
>> thing; however, if the first version of the patch is applied, then
>> some changes around the same area of the file occur _then_ when the
>> second version (of the same patch differing only by SHA1) is applied
>> Git will get confused.  If it has the same SHA1 however, Git will
>> discard it as 'already applied'.  This is the reason we pass around
>> shared tags to immutable branches.
> Looking at how the patch is trivial, I persist to think there is no issue.
> But OK, I will prepare an immutable branch..

I've pushed this to
git://git.kernel.org/pub/scm/linux/kernel/git/kishon/linux-phy.git
tags/phy-dt-header

I generally use 'git rebase' since that doesn't create a separate merge commit,
but it's up to you,

Thanks
Kishon
