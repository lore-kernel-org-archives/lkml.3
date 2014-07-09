Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755299AbaGIJnD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 05:43:03 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:33708 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754201AbaGIJnA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 05:43:00 -0400
MIME-Version: 1.0
In-Reply-To: <1404745893-6379-1-git-send-email-iivanov@mm-sol.com>
References: <1404745893-6379-1-git-send-email-iivanov@mm-sol.com>
Date: Wed, 9 Jul 2014 11:43:00 +0200
Message-ID: <CACRpkdYcoA-nifxojO5tZUy6dL6P2PTSGW0mVLUfqG20rOg-Nw@mail.gmail.com>
Subject: Re: [PATCH 0/4] New Qualcomm PMIC pin controller drivers
From: Linus Walleij <linus.walleij@linaro.org>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Bjorn Andersson <Bjorn.Andersson@sonymobile.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 7, 2014 at 5:11 PM, Ivan T. Ivanov <iivanov@mm-sol.com> wrote:

> This set of patches adds pin control drivers for Multi-purpose
> pin (MPP) and General-purpose pin (GPIO) controllers found
> in Qualcomm PMIC chips.
>
> MPP's are enhanced GPIO's with analog circuits, which support
> following functions in addition to digital input/output: analog
> input/output and current sinks.
>
> PMIC PM8941 have 8 MPP's and 36 GPIO's. PMIC PM8841 have 4 MPP's.
>
> Ivan T. Ivanov (4):
>   pinctrl: qpnp: Qualcomm PMIC pin controller driver
>   pinctrl: qcom: Add documentation for pinctrl-qpnp binding
>   pinctrl: qcom: Add PM8941 and PM8941 pinctrl drivers
>   ARM: dts: qcom: Add PM8941 and PM8841 pinctrl nodes

Oh, I just spent some 45 minutes reviewing an 8xxx pinctrl driver from
Björn Andersson
that *seems* to be doing exactly the same thing.

Now I have two drivers from people outside Qualcomm :-)

Some of my review comments on Björn's driver (like using SI units with the pin
config) are actually adressed in this patch set. The idea to split in subdrivers
per-ASIC may be good? I don't really know.

Can you two guys *PLEASE* join efforts and combine your drivers into one?

If we do this efficiently it should be possible to get one single real
nice driver
in the end.

If you start arguing about nittt gritty stuff like who's going to be author on
the commit I'll get really disappointed ;-)

Yours,
Linus Walleij
