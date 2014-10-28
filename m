Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752600AbaJ1Q3N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 12:29:13 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:37812 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751695AbaJ1Q3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 12:29:11 -0400
MIME-Version: 1.0
In-Reply-To: <1413971927-9168-1-git-send-email-iivanov@mm-sol.com>
References: <1413971927-9168-1-git-send-email-iivanov@mm-sol.com>
Date: Tue, 28 Oct 2014 17:29:10 +0100
Message-ID: <CACRpkdaq8Y_+JHTjZWmWQUh9xnSSGOd+-XVpZeutfwRaZXTQxQ@mail.gmail.com>
Subject: Re: [PATCH v6 0/4] Qualcomm SPMI PMIC pin controller drivers
From: Linus Walleij <linus.walleij@linaro.org>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
Cc: Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Georgi Djakov <gdjakov@mm-sol.com>, Andy Gross <agross@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2014 at 11:58 AM, Ivan T. Ivanov <iivanov@mm-sol.com> wrote:

> Changes since v4:
>
> - Rebased on v3.18-rc1:
>   pinmux_ops.enable is now pinmux_ops.set_mux
>   gpiochip_remove() did not return a value.
> - Added Ack's from Bjorn

Thanks guys, I have applied the latest version of the v6 patch series,
including the v6-prim version of 3/4 that fixed the compile error...

Unless something radically bad happens it goes into v3.19.

Yours,
Linus Walleij
