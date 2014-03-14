Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754113AbaCNKOh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 06:14:37 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:53405 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752316AbaCNKOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 06:14:34 -0400
MIME-Version: 1.0
In-Reply-To: <53207CA2.4090309@st.com>
References: <1394614210-15698-1-git-send-email-maxime.coquelin@st.com>
	<CACRpkdboBkzcJC35-BNvVYmS_t9Cd204AVz4rZasKtNJp0yE4g@mail.gmail.com>
	<53207CA2.4090309@st.com>
Date: Fri, 14 Mar 2014 11:14:34 +0100
Message-ID: <CACRpkdZ7NpQBnpKLWSMST6fW9ST_tHi6L66jTQ4kh=+ONfjMgg@mail.gmail.com>
Subject: Re: [PATCH v4 0/6] Add STiH407 SoC and reference board support
From: Linus Walleij <linus.walleij@linaro.org>
To: Maxime Coquelin <maxime.coquelin@st.com>
Cc: Rob Landley <rob@landley.net>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>,
        Stuart Menefy <stuart.menefy@st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        kernel@stlinux.com, Lee Jones <lee.jones@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2014 at 4:26 PM, Maxime Coquelin <maxime.coquelin@st.com> wrote:
> On 03/12/2014 03:20 PM, Linus Walleij wrote:

>> I've applied the pinctrl changes to the pinctrl tree, please push all the
>> DTS[i] changes through ARM SoC.
>
> As mentioned in the cover-letter, the DTS changes are based on arm_soc's
> for-next branch.
>
> Do you mean I should send a pull request for these three patches?

You'd have to ask the ARM SoC maintainers, but if it's a few patches
they can also apply them directly on the target branch.

Yours,
Linus Walleij
