Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751664AbaAOKIn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 05:08:43 -0500
Received: from mail-ob0-f176.google.com ([209.85.214.176]:53141 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705AbaAOKIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 05:08:38 -0500
MIME-Version: 1.0
In-Reply-To: <1389711125-21007-1-git-send-email-srinivas.kandagatla@st.com>
References: <1389711077-20949-1-git-send-email-srinivas.kandagatla@st.com>
	<1389711125-21007-1-git-send-email-srinivas.kandagatla@st.com>
Date: Wed, 15 Jan 2014 11:08:37 +0100
Message-ID: <CACRpkdbjUvAkoQ67JDDbRAQp6jYO1Vz44mG_HY2Yz_-fxd76Uw@mail.gmail.com>
Subject: Re: [PATCH v1 1/5] pinctrl: st: Fix a typo in probe
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

On Tue, Jan 14, 2014 at 3:52 PM,  <srinivas.kandagatla@st.com> wrote:

> From: Srinivas Kandagatla <srinivas.kandagatla@st.com>
>
> Probe function had commas instead of semi-colons on some of the lines.
> This patch just fixes those lines. No functional chagnes done in this
> patch.
>
> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>

Patch applied!

Yours,
Linus Walleij
