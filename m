Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752981Ab3AVNZh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 08:25:37 -0500
Received: from mail-ie0-f178.google.com ([209.85.223.178]:37360 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998Ab3AVNZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 08:25:36 -0500
MIME-Version: 1.0
In-Reply-To: <20130122032538.GI7409@sortiz-mobl>
References: <1357546398-9541-1-git-send-email-linus.walleij@stericsson.com>
	<20130122032538.GI7409@sortiz-mobl>
Date: Tue, 22 Jan 2013 14:25:35 +0100
Message-ID: <CACRpkdaa+bFpmSi8wRiNjyGayP_jW63+_QqbyyNDTPkKinpv5w@mail.gmail.com>
Subject: Re: [PATCH] mfd: prcmu: delete pin control helpers
From: Linus Walleij <linus.walleij@linaro.org>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        Anmar Oueja <anmar.oueja@linaro.org>,
        Loic Pallardy <loic.pallardy@st.com>,
        Patrice Chotard <patrice.chotard@st.com>,
        Michel Jaouen <michel.jaouen@st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 22, 2013 at 4:25 AM, Samuel Ortiz <sameo@linux.intel.com> wrote:
> On Mon, Jan 07, 2013 at 09:13:18AM +0100, Linus Walleij wrote:
>> From: Linus Walleij <linus.walleij@linaro.org>
>>
>> These static inlines are duplicating the task now done by the
>> Nomadik pinctrl drivers, so delete them from the prcmu static
>> inlines, also delete the register definitions as these should
>> only be known by the pinctrl driver.
>>
>> Cc: Loic Pallardy <loic.pallardy@st.com>
>> Cc: Patrice Chotard <patrice.chotard@st.com>
>> Cc: Michel Jaouen <michel.jaouen@st.com>
>> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
>> ---
>> Sam, this is a pure clean-up patch following the v3.8 merge
>> window. These inlines are completely unused in the kernel and
>> I'd simply apply it to the -rc series but it's up to you.
>
> Unless it really makes your life easier, I like to keep my -rc pull requests
> for fixes only.
> I'll apply it to my for-next branch for now.

OK in that case, can I take it through the ARM SoC tree
with your ACK, because I have other cleanups that depend on
this one?

Yours,
Linus Walleij
