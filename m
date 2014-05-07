Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754AbaEGOnK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 10:43:10 -0400
Received: from mail-ve0-f180.google.com ([209.85.128.180]:64537 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753281AbaEGOnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 10:43:06 -0400
MIME-Version: 1.0
In-Reply-To: <5369F0D6.3080503@st.com>
References: <1399408005-4209-1-git-send-email-festevam@gmail.com>
	<5369F0D6.3080503@st.com>
Date: Wed, 7 May 2014 11:43:05 -0300
Message-ID: <CAOMZO5CoSJB1kqBMoE6_8WL_WektBC0RXWbk60wPi=tbYJK_Og@mail.gmail.com>
Subject: Re: [PATCH] clk: clk-divider: Fix infinite loop for table divider
From: Fabio Estevam <festevam@gmail.com>
To: Maxime Coquelin <maxime.coquelin@st.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Shawn Guo <shawn.guo@freescale.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 7, 2014 at 5:37 AM, Maxime Coquelin <maxime.coquelin@st.com> wrote:

> Couldn't we initialize "up" variable to INT_MAX in _round_up_table() as I
> just proposed in mail thread reporting the regression?

Yes, it works fine. Please submit your version.

Thanks
