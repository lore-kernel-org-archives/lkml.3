Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756288Ab3FRPvk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 11:51:40 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:43344 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756166Ab3FRPvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 11:51:39 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdZxpm_C8K2Rn3hV=kqAK2p0mip4f1Rx=B9+2g7NXpCd=w@mail.gmail.com>
References: <1371546267-22093-1-git-send-email-sachin.kamat@linaro.org>
	<1371546267-22093-4-git-send-email-sachin.kamat@linaro.org>
	<CACRpkdZxpm_C8K2Rn3hV=kqAK2p0mip4f1Rx=B9+2g7NXpCd=w@mail.gmail.com>
Date: Tue, 18 Jun 2013 21:21:38 +0530
Message-ID: <CAK9yfHwYO=jZeL6QERWTXMY-bReveNKZCiZz1t60toFQoYr8bQ@mail.gmail.com>
Subject: Re: [PATCH 4/4] pinctrl: Staticize local symbols
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Patrice Chotard <patrice.chotard@st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18 June 2013 20:25, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Tue, Jun 18, 2013 at 11:04 AM, Sachin Kamat <sachin.kamat@linaro.org> wrote:
>
>> Symbols referenced only in this file are made static.
>>
>> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
>> Cc: Patrice Chotard <patrice.chotard@st.com>
>
> Excellent observation Sachin, patch applied.

Thanks.




-- 
With warm regards,
Sachin
