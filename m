Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933191Ab3E1HGq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 03:06:46 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:42939 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932959Ab3E1HGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 03:06:45 -0400
MIME-Version: 1.0
In-Reply-To: <1369397191-16643-1-git-send-email-patrice.chotard.st@gmail.com>
References: <1369397191-16643-1-git-send-email-patrice.chotard.st@gmail.com>
Date: Tue, 28 May 2013 09:06:45 +0200
Message-ID: <CACRpkdYBcQJhVeSV8YUUG3gXTNnbRLt5mMiDX2gCpU02VyDehA@mail.gmail.com>
Subject: Re: [PATCH 0/3] pinctrl: abx500: Fix pull up/down feature
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

On Fri, May 24, 2013 at 2:06 PM,  <patrice.chotard.st@gmail.com> wrote:

> From: Patrice Chotard <patrice.chotard@st.com>
>
> This series fixes the pull up/down feature of ABx500 family ASIC.
>
> Patrice Chotard (3):
>   pinctrl: abx500: fix abx500_config_pull_updown
>   pinctrl: abx500: allow to set pull up
>   pinctrl: abx500: fix abx500_gpio_dbg_show_one() to show pull up/down
>
>  drivers/pinctrl/pinctrl-abx500.c |  110 ++++++++++++++++++++++++++++++++------
>  1 file changed, 93 insertions(+), 17 deletions(-)

All three patches applied, thanks!

Yours,
Linus Walleij
