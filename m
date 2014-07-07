Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752257AbaGGPc0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 11:32:26 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:47327 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752119AbaGGPcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 11:32:24 -0400
MIME-Version: 1.0
In-Reply-To: <1403711344-17335-1-git-send-email-patrice.chotard@st.com>
References: <1403711344-17335-1-git-send-email-patrice.chotard@st.com>
Date: Mon, 7 Jul 2014 17:32:24 +0200
Message-ID: <CACRpkdY64C0PNEK+E_AVhhxvJMXOiesFHOcvFpRpoTrfb0dtMw@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: st: add IRQCHIP_SKIP_SET_WAKE flag
From: Linus Walleij <linus.walleij@linaro.org>
To: Patrice CHOTARD <patrice.chotard@st.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        kernel@stlinux.com, Maxime Coquelin <maxime.coquelin@st.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2014 at 5:49 PM, Patrice CHOTARD <patrice.chotard@st.com> wrote:

> From: David PARIS <david.paris@st.com>
>
> no .irq_set_wake API is available for pinctrl-st driver.
> Add the IRQCHIP_SKIP_SET_WAKE flag to inform irq handler
> not to call this API.
>
> Signed-off-by: David Paris <david.paris@st.com>

Patch applied - had to rebase it, strangely the struct is different in
my tree (check that you're in sync).

Yours,
Linus Walleij
