Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755563AbaAWHaR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 02:30:17 -0500
Received: from mail-oa0-f50.google.com ([209.85.219.50]:51693 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753731AbaAWHaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 02:30:14 -0500
MIME-Version: 1.0
In-Reply-To: <1389886657-32035-1-git-send-email-srinivas.kandagatla@st.com>
References: <1389886545-31498-1-git-send-email-srinivas.kandagatla@st.com>
	<1389886657-32035-1-git-send-email-srinivas.kandagatla@st.com>
Date: Thu, 23 Jan 2014 08:30:13 +0100
Message-ID: <CACRpkdZ7xK_2zt8XK87YrHGtimjOgVuVnGBNc11eGQcd3uySfw@mail.gmail.com>
Subject: Re: [PATCH v2 3/4] ARM:STi: STiH416: Add interrupt support for pin controller
From: Linus Walleij <linus.walleij@linaro.org>
To: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 16, 2014 at 4:37 PM,  <srinivas.kandagatla@st.com> wrote:

> From: Srinivas Kandagatla <srinivas.kandagatla@st.com>
>
> This patch adds interrupt support for STiH416 pin controllers.
>
> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Please merge this through the ARM SoC tree with the rest of
your device tree stuff.

Yours,
Linus Walleij
