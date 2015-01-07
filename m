Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756785AbbAGJpN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 04:45:13 -0500
Received: from mail-ig0-f182.google.com ([209.85.213.182]:33738 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755870AbbAGJpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 04:45:10 -0500
MIME-Version: 1.0
In-Reply-To: <1420452254-30625-3-git-send-email-patrice.chotard@st.com>
References: <1420452254-30625-1-git-send-email-patrice.chotard@st.com>
	<1420452254-30625-3-git-send-email-patrice.chotard@st.com>
Date: Wed, 7 Jan 2015 10:45:10 +0100
Message-ID: <CACRpkdb9cHaKe3a5rr2w9WVUOp7um9P41j8c4MYZTf0APHXsKA@mail.gmail.com>
Subject: Re: [RESEND PATCH 2/2] pinctrl: st: Add irq_disable hook to st_gpio_irqchip
From: Linus Walleij <linus.walleij@linaro.org>
To: Patrice CHOTARD <patrice.chotard@st.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 5, 2015 at 11:04 AM, Patrice CHOTARD <patrice.chotard@st.com> wrote:

> Currently disable_irq() doesn't work for pinctrl-st driver, due to
> missing irq_disable hook in the driver.
> disable_irq() is required only for level-triggered interrupts, which
> is not the case normally.
>
> Signed-off-by: Pankaj Dev <pankaj.dev@st.com>
> Signed-off-by: Patrice Chotard <patrice.chotard@st.com>

Patch applied to fixes. Sorry for the delay.

Yours,
Linus Walleij
