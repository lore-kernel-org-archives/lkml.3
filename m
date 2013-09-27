Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753578Ab3I0Nvb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 09:51:31 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:60810 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185Ab3I0Nv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 09:51:29 -0400
MIME-Version: 1.0
In-Reply-To: <1380035051-24526-1-git-send-email-m.krawczuk@partner.samsung.com>
References: <1380035051-24526-1-git-send-email-m.krawczuk@partner.samsung.com>
Date: Fri, 27 Sep 2013 15:51:28 +0200
Message-ID: <CACRpkdbrBRagZ01w+OFbAdf+xX6zfqEBYPRY9OxRtxCH5Ln1og@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: Correct number of pins for s5pv210
From: Linus Walleij <linus.walleij@linaro.org>
To: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
Cc: Tomasz Figa <t.figa@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 24, 2013 at 5:04 PM, Mateusz Krawczuk
<m.krawczuk@partner.samsung.com> wrote:

> Values of pins in table s5pv210 bank are incorrect. This patch correct values.
>
> Signed-off-by: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

Patch applied for fixes with the ACKs from Tomasz and Kukjin.

Yours,
Linus Walleij
