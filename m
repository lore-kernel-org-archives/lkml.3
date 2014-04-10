Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935505AbaDJSIy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 14:08:54 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:40715 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934663AbaDJSIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 14:08:52 -0400
MIME-Version: 1.0
In-Reply-To: <1396970509-28009-3-git-send-email-maxime.coquelin@st.com>
References: <1396970509-28009-1-git-send-email-maxime.coquelin@st.com>
	<1396970509-28009-3-git-send-email-maxime.coquelin@st.com>
Date: Thu, 10 Apr 2014 20:08:52 +0200
Message-ID: <CACRpkdaT7R6goqOod6ZH15FeA3Q=M_vSUPOiQHAUTg8SqOXWwA@mail.gmail.com>
Subject: Re: [PATCH 2/2] pinctrl: st: Use ARRAY_SIZE for STiH415 data
From: Linus Walleij <linus.walleij@linaro.org>
To: Maxime COQUELIN <maxime.coquelin@st.com>
Cc: Joe Perches <joe@perches.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kernel@stlinux.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 8, 2014 at 5:21 PM, Maxime COQUELIN <maxime.coquelin@st.com> wrote:

> This patch completes the one that used ARRAY_SIZE for STiH407 and STiH416
> for setting ninput_delays and noutput_delays fields.
>
> Signed-off-by: Maxime Coquelin <maxime.coquelin@st.com>

Patch applied.

Yours,
Linus Walleij
