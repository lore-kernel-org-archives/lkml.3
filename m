Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031828AbaGDXEQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 19:04:16 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:52205 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030901AbaGDXEL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 19:04:11 -0400
MIME-Version: 1.0
In-Reply-To: <539A0FE9.1080802@wwwdotorg.org>
References: <1402398708-10722-1-git-send-email-thierry.reding@gmail.com>
	<1402398708-10722-2-git-send-email-thierry.reding@gmail.com>
	<539A0FE9.1080802@wwwdotorg.org>
Date: Sat, 5 Jul 2014 01:04:10 +0200
Message-ID: <CACRpkdZvO-RZZKDtbFY6Uv5Td2NJ828xj0sVbTh2=ehx7Ha6fA@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] pinctrl: Add NVIDIA Tegra XUSB pad controller support
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Thierry Reding <thierry.reding@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Andrew Bresticker <abrestic@chromium.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2014 at 10:39 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 06/10/2014 05:11 AM, Thierry Reding wrote:

> Aside from the issue Andrew pointed out, this series looks good to me.
> I'll apply once that one issue is fixed.
>
> Linus,
>
> Patch 2 (pinctrl driver) depends on patch 1 (binding header), and there
> are other patches that will also depend on the binding header in patch
> 1. I guess I should apply patch 1 in a topic branch and send you a pull
> request which you can merge before applying patch 2. Does that sound OK
> to you?

Bah I've got some mess in my mailbox.

Please proceed as this Stephen, I trust your pull request will
be fine.

Yours,
Linus Walleij
