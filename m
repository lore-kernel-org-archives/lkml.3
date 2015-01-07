Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756741AbbAGJoo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 04:44:44 -0500
Received: from mail-ig0-f170.google.com ([209.85.213.170]:63933 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755428AbbAGJoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 04:44:12 -0500
MIME-Version: 1.0
In-Reply-To: <1420452254-30625-2-git-send-email-patrice.chotard@st.com>
References: <1420452254-30625-1-git-send-email-patrice.chotard@st.com>
	<1420452254-30625-2-git-send-email-patrice.chotard@st.com>
Date: Wed, 7 Jan 2015 10:44:11 +0100
Message-ID: <CACRpkdbOftsepHFBv32j-ty2+N3vDJPP27iMEWwZKO3ciRv0ug@mail.gmail.com>
Subject: Re: [RESEND PATCH 1/2] pinctrl: st: avoid multiple mutex lock
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

> From: Francesco VIRLINZI <francesco.virlinzi@st.com>
>
> Using the sysfs inteface to inspect the pins configuration
> the system can walk around a path which acquires the same
> mutex twice.
>
> On STiH407 platform, for example :
> cat /sys/kernel/debug/pinctrl/920f080.pin-controller-front0/pinconf-pins
> hangs the kernel and never returns.
>
> With this patch the mutex is temporary freed.
>
> Signed-off-by: Francesco Virlinzi <francesco.virlinzi@st.com>
> Signed-off-by: Patrice Chotard <patrice.chotard@st.com>

Patch applied to fixes. Sorry for the delay.

Yours,
Linus Walleij
