Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753711Ab3F1MQr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 08:16:47 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41085 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150Ab3F1MQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 08:16:46 -0400
MIME-Version: 1.0
X-Originating-IP: [111.255.123.51]
In-Reply-To: <51CD6743.3050603@st.com>
References: <1372415628.1860.1.camel@phoenix>
	<51CD6743.3050603@st.com>
Date: Fri, 28 Jun 2013 20:16:45 +0800
Message-ID: <CAFRkauBbajREymRRZ8rbB6nzw4KgPWSd684Qz75MekcLzpoR=g@mail.gmail.com>
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
> Thankyou Axel for looking at this.
>
> There is already a patch is submitted for this.
> https://lkml.org/lkml/2013/6/26/494 which I have Acked.

That is strange.
I don't think the patch you mentioned can be applied to current pinctrl tree.
Current code does check pinctrl_register by IS_ERR.

        info->pctl = pinctrl_register(pctl_desc, &pdev->dev, info);
        if (IS_ERR(info->pctl)) {

Regards,
Axel
