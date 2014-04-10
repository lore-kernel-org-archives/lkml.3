Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030371AbaDJSHi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 14:07:38 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:57879 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753103AbaDJSHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 14:07:36 -0400
MIME-Version: 1.0
In-Reply-To: <1396970509-28009-2-git-send-email-maxime.coquelin@st.com>
References: <1396970509-28009-1-git-send-email-maxime.coquelin@st.com>
	<1396970509-28009-2-git-send-email-maxime.coquelin@st.com>
Date: Thu, 10 Apr 2014 20:07:35 +0200
Message-ID: <CACRpkda9yEx09WDmwUTjYz64u6YTKw5wpwOUVeMwN-4=O004CA@mail.gmail.com>
Subject: Re: [PATCH 1/2] pinctrl: st: Use const qualifier when required
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

> This patch adds const qualifier where applicable.
>
> CC: Linus Walleij <linus.walleij@linaro.com>
> Reported-by: Joe Perches <joe@perches.com>
>
> Signed-off-by: Maxime Coquelin <maxime.coquelin@st.com>

Patch applied.

Yours,
Linus Walleij
