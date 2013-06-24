Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752724Ab3FXLUa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 07:20:30 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:45297 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979Ab3FXLU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 07:20:29 -0400
MIME-Version: 1.0
In-Reply-To: <1371737100-27584-3-git-send-email-patrice.chotard.st@gmail.com>
References: <1371737100-27584-1-git-send-email-patrice.chotard.st@gmail.com>
	<1371737100-27584-3-git-send-email-patrice.chotard.st@gmail.com>
Date: Mon, 24 Jun 2013 13:20:29 +0200
Message-ID: <CACRpkdZ0ss-uM7VJYMVVY45bK=DuCYtnVkJcVJJAV5xdkqrH5g@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] pinctrl: abx500: fix abx500_pin_config_set()
From: Linus Walleij <linus.walleij@linaro.org>
To: Patrice Chotard <patrice.chotard.st@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Olivier Clergeaud <olivier.clergeaud@st.com>,
        Lee Jones <lee.jones@linaro.org>,
        Fabio Baltieri <fabio.baltieri@linaro.org>,
        Patrice Chotard <patrice.chotard@st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 20, 2013 at 4:05 PM,  <patrice.chotard.st@gmail.com> wrote:

> From: Patrice Chotard <patrice.chotard@st.com>
>
> _ Update abx500_pin_config_set() in order to take in
> account PIN_CONFIG_BIAS_DISABLE state to disable
> pull up or pull down.
>
> _ Rework error path.
>
> Signed-off-by: Patrice Chotard <patrice.chotard@st.com>

This v2 patch applied, thanks!
Linus Walleij
