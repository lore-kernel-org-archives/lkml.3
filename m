Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755215Ab3F1OY0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 10:24:26 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:36544 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752743Ab3F1OYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 10:24:25 -0400
MIME-Version: 1.0
X-Originating-IP: [111.255.123.51]
In-Reply-To: <51CD95FE.6070205@st.com>
References: <1372415628.1860.1.camel@phoenix>
	<51CD6743.3050603@st.com>
	<CAFRkauBbajREymRRZ8rbB6nzw4KgPWSd684Qz75MekcLzpoR=g@mail.gmail.com>
	<51CD95FE.6070205@st.com>
Date: Fri, 28 Jun 2013 22:24:24 +0800
Message-ID: <CAFRkauAW4kvhYhmRipuX6Me6oYV4mEkjGiPGX_Dup+hj6CicmA@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: st: Fix checking return value of syscon_regmap_lookup_by_phandle()
From: Axel Lin <axel.lin@ingics.com>
To: srinivas.kandagatla@st.com
Cc: Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/6/28 Srinivas KANDAGATLA <srinivas.kandagatla@st.com>:
> On 28/06/13 13:16, Axel Lin wrote:
>> 2013/6/28 Srinivas KANDAGATLA <srinivas.kandagatla@st.com>:
>>> Thankyou Axel for looking at this.
>>>
>>> There is already a patch is submitted for this.
>>> https://lkml.org/lkml/2013/6/26/494 which I have Acked.
>>
>> That is strange.
>> I don't think the patch you mentioned can be applied to current pinctrl tree.
>> Current code does check pinctrl_register by IS_ERR.
> The patch removes the IS_ERR, because, pinctrl_register returns NULL or
> a valid pointer, using IS_ERR is this case is incorrect.
You are right.

Thanks,
Axel
