Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753926AbbAUQny (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 11:43:54 -0500
Received: from mail-ig0-f174.google.com ([209.85.213.174]:63574 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752974AbbAUQnq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 11:43:46 -0500
MIME-Version: 1.0
In-Reply-To: <1421745476-6276-1-git-send-email-svarbanov@mm-sol.com>
References: <1421745476-6276-1-git-send-email-svarbanov@mm-sol.com>
Date: Wed, 21 Jan 2015 17:43:46 +0100
Message-ID: <CACRpkdY31g+qBumZzWgHj7ZC9rROTwE3AgLhJGB+FPtmMk6iTg@mail.gmail.com>
Subject: Re: [PATCH 0/3] pinctrl: Qualcomm msm8916 pinctrl driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Stanimir Varbanov <svarbanov@mm-sol.com>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Joonwoo Park <joonwoop@codeaurora.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2015 at 10:17 AM, Stanimir Varbanov
<svarbanov@mm-sol.com> wrote:

> This series adds a pinctrl driver for Snapdragon 410 (msm8916) SoC. The first
> patch increase the register address variable size, next adds a binding document
> and the last patch adds the pinctrl driver
>
> Comments are welcome!

Björn can you look at this?

Yours,
Linus Walleij
