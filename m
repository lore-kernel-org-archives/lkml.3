Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422657AbaD3P2A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 11:28:00 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:50275 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752084AbaD3P17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 11:27:59 -0400
MIME-Version: 1.0
In-Reply-To: <1398864419.14545.8.camel@AMDC1943>
References: <1398864419.14545.8.camel@AMDC1943>
Date: Wed, 30 Apr 2014 20:57:58 +0530
Message-ID: <CAK9yfHwge_4HFzqj+4kgcY+fQTy1uQBp-=RhyX2YYRt3hKLPXA@mail.gmail.com>
Subject: Re: Idea: regulator: Merge s2mpa01 with s2mps11
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Sachin Kamat <sachin.kamat@samsung.com>, Mark Brown <broonie@linaro.org>,
        Sangbeom Kim <sbkim73@samsung.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Krzysztof,

On 30 April 2014 18:56, Krzysztof Kozlowski <k.kozlowski@samsung.com> wrote:
> Dear Sachin,
>
>
> The S2MPA01 and S2MPS1X PMICs regulator drivers look quite similar to
> each other. Most of the S2MPA01 driver is the same as S2MPS11 (except
> changes added for supporting S2MPS14).
>
> I would like to merge these drivers into one. However I do not have
> neither any board with S2MPA01 nor S2MPA01 datasheet.
>
> What do you think about merging them?

It is a good idea to merge them. That was my initial plan too.
I appreciate your offer to do the same.

>Could you test it later when I will finish the development?

I will not be able to do it immediately though as currently I am involved
with some other activity on a different h/w and will be on vacation for some
time later next week onwards.

-- 
With warm regards,
Sachin
