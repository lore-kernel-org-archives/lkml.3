Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752965AbaGWMrg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 08:47:36 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:62635 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475AbaGWMre convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 08:47:34 -0400
MIME-Version: 1.0
In-Reply-To: <1405610748-7583-1-git-send-email-iivanov@mm-sol.com>
References: <1405610748-7583-1-git-send-email-iivanov@mm-sol.com>
Date: Wed, 23 Jul 2014 14:47:33 +0200
Message-ID: <CACRpkdZCj0OwAwqjiBXQumEs3oeQuMeAFy7T5MCaVAvTBqS7Nw@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] New Qualcomm PMIC pin controller drivers
From: Linus Walleij <linus.walleij@linaro.org>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Mark Brown <broonie@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2014 at 5:25 PM, Ivan T. Ivanov <iivanov@mm-sol.com> wrote:

> Patches could be applied on top of the Bjorn Andersson
> qcom,pm8xxx-gpio driver, which could be found here[2].
>
> Fist patch modify Bjorn's driver and bindings to make room
> for newer Qualcomm PMIC chips. It is not completely ready.

I like what I'm seeing :-)

Good cooperation and joint efforts. That's the spirit!

In the end, Björn can you provide a pullable branch for me?

This will likely be v3.18 development cycle material as
the v3.17 merge window is quite close.

Yours,
Linus Walleij
