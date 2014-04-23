Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374AbaDWLnn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 07:43:43 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:37509 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752912AbaDWLnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 07:43:41 -0400
MIME-Version: 1.0
In-Reply-To: <a6a34db97a1cdcc21d0a7675d8ee31eb9bced399.1397741024.git.silvio.fricke@gmail.com>
References: <20140417061136.GD11602@dragon>
	<cover.1397741024.git.silvio.fricke@gmail.com>
	<a6a34db97a1cdcc21d0a7675d8ee31eb9bced399.1397741024.git.silvio.fricke@gmail.com>
Date: Wed, 23 Apr 2014 13:43:41 +0200
Message-ID: <CACRpkdZSomAddBw3Oxbangt=kD7zO4UG78mVEV=CrG31gCse_g@mail.gmail.com>
Subject: Re: [PATCH] ARM: dts: imx6: edmqmx6: add vcc and vio power supplies
 to stmpe
From: Linus Walleij <linus.walleij@linaro.org>
To: Silvio Fricke <silvio.fricke@gmail.com>
Cc: Shawn Guo <shawn.guo@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Viresh Kumar <viresh.linux@gmail.com>,
        Shiraz Hashim <shiraz.hashim@st.com>,
        spear-devel <spear-devel@list.st.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2014 at 3:28 PM, Silvio Fricke <silvio.fricke@gmail.com> wrote:

> Signed-off-by: Silvio Fricke <silvio.fricke@gmail.com>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

As long as Lee is happy with the optional regulators this should be fine
to apply orthogonally through ARM SoC.

Yours,
Linus Walleij
