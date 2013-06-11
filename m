Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754442Ab3FKIzr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 04:55:47 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:45213 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752230Ab3FKIzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 04:55:46 -0400
MIME-Version: 1.0
In-Reply-To: <1370940501-11029-1-git-send-email-patrice.chotard.st@gmail.com>
References: <1370940501-11029-1-git-send-email-patrice.chotard.st@gmail.com>
Date: Tue, 11 Jun 2013 10:55:45 +0200
Message-ID: <CACRpkdYkAFcQYd3Lc3v0H2T6kGz8mCmoenm1Dmh5GbdvQMMDeg@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: abx500: fix build warning
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

On Tue, Jun 11, 2013 at 10:48 AM,  <patrice.chotard.st@gmail.com> wrote:

> From: Patrice Chotard <patrice.chotard@st.com>
>
> pinctrl-abx500.c: In function 'abx500_gpio_dbg_show_one':
> pinctrl-abx500.c:534:14: warning: 'pud' may be used
> uninitialized in this function [-Wuninitialized]
>
> Signed-off-by: Patrice Chotard <patrice.chotard@st.com>

Patch applied, thanks!

Yours,
Linus Walleij
