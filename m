Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760155Ab3HNTQV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 15:16:21 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:55088 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758446Ab3HNTQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 15:16:19 -0400
MIME-Version: 1.0
In-Reply-To: <52026F0B.6020705@wwwdotorg.org>
References: <1374702089-2832-1-git-send-email-hanumant@codeaurora.org>
	<CACRpkdZLFD-KAvZdUUvQKje3vAH1D0EJMW9PSK8VSp3Xs4eiGA@mail.gmail.com>
	<51F82BCC.1080409@codeaurora.org>
	<51F82E9F.9010309@wwwdotorg.org>
	<51F853BF.9040007@codeaurora.org>
	<51F8556A.1010300@wwwdotorg.org>
	<51F85690.9060701@codeaurora.org>
	<51F88BAC.2020001@wwwdotorg.org>
	<51F969A5.5020405@codeaurora.org>
	<51F97C47.5020202@wwwdotorg.org>
	<51F9A934.404@codeaurora.org>
	<52018A8D.70608@codeaurora.org>
	<52026F0B.6020705@wwwdotorg.org>
Date: Wed, 14 Aug 2013 21:16:18 +0200
Message-ID: <CACRpkdbWmb2Kmj8NVBpJh4zumpq-=z=hFnRY9uWrARi5uSfwOQ@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: msm: Add support for MSM TLMM pinmux
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Hanumant Singh <hanumant@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bjorn Andersson <Bjorn.Andersson@sonymobile.com>,
        "Bird, Tim" <Tim.Bird@sonymobile.com>,
        ext Tony Lindgren <tony@atomide.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 7, 2013 at 6:00 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 08/06/2013 05:45 PM, Hanumant Singh wrote:

>> Any comments on this?
>
> No. As I said, I personally want to see all the pingroups defined in the
> pinctrl driver. But, if someone else acks/... the patches without it, I
> probably won't nack it.

I agree with Stephen that I want to see the groups defined in a
(per-SoC) in-kernel driver, not as DT data.

Yours,
Linus Walleij
