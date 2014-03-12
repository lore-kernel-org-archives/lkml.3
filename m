Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754545AbaCLOTK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 10:19:10 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:36846 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754189AbaCLOTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 10:19:07 -0400
MIME-Version: 1.0
In-Reply-To: <1394614210-15698-5-git-send-email-maxime.coquelin@st.com>
References: <1394614210-15698-1-git-send-email-maxime.coquelin@st.com>
	<1394614210-15698-5-git-send-email-maxime.coquelin@st.com>
Date: Wed, 12 Mar 2014 15:19:06 +0100
Message-ID: <CACRpkdYBZKcuyNyD08K00COLXPYd7HRrapNaWLAW9SK7o0OVaQ@mail.gmail.com>
Subject: Re: [PATCH v4 4/6] pinctrl: st: Use ARRAY_SIZE instead of raw value
 for number of delays
From: Linus Walleij <linus.walleij@linaro.org>
To: Maxime COQUELIN <maxime.coquelin@st.com>
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

On Wed, Mar 12, 2014 at 9:50 AM, Maxime COQUELIN <maxime.coquelin@st.com> wrote:

> This patch replaces the raw values with ARRAY_SIZE for assigning the
> ninput_delays and noutput_delays fields of STiH416's st_pctl_data struct.
>
> CC: Lee Jones <lee.jones@linaro.org>
> Acked-by: Giuseppe Cavallaro <peppe.cavallaro@st.com>
> Signed-off-by: Maxime Coquelin <maxime.coquelin@st.com>

Patch applied!

Yours,
Linus Walleij
