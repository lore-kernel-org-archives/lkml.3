Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755444Ab3H1Mvr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 08:51:47 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:64002 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754393Ab3H1Mvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 08:51:45 -0400
MIME-Version: 1.0
In-Reply-To: <1377608890-8528-1-git-send-email-m.krawczuk@partner.samsung.com>
References: <1377608890-8528-1-git-send-email-m.krawczuk@partner.samsung.com>
Date: Wed, 28 Aug 2013 14:51:44 +0200
Message-ID: <CACRpkdYiB5OG-YPRozwEurPHECDzZjQUs2s_E8gCdeqDPyr+WA@mail.gmail.com>
Subject: Re: [Patch v2] pinctrl: Add s5pv210 support to pinctrl-exynos
From: Linus Walleij <linus.walleij@linaro.org>
To: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>, Rob Landley <rob@landley.net>,
        Tomasz Figa <t.figa@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Leelakrishna A <l.krishna@samsung.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 27, 2013 at 3:08 PM, Mateusz Krawczuk
<m.krawczuk@partner.samsung.com> wrote:

> This patch implements pinctrl support and adds device tree bindings
> for s5pv210.
>
> Signed-off-by: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>

Oh this one does add bindings, sorry for previous comment.

I want an ACK from Kukjin or Sylwester for this since it's
something new for S5P.

Yours,
Linus Walleij
