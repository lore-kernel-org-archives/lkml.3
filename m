Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752656Ab3FXLSV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 07:18:21 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:55018 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979Ab3FXLST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 07:18:19 -0400
MIME-Version: 1.0
In-Reply-To: <1371737100-27584-2-git-send-email-patrice.chotard.st@gmail.com>
References: <1371737100-27584-1-git-send-email-patrice.chotard.st@gmail.com>
	<1371737100-27584-2-git-send-email-patrice.chotard.st@gmail.com>
Date: Mon, 24 Jun 2013 13:18:19 +0200
Message-ID: <CACRpkdYVnZdWhbuFi37zn+-ahvkCxbQ2TgGwK71-Sg+i+iNnhA@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] pinctrl: abx500: Add device tree support
From: Linus Walleij <linus.walleij@linaro.org>
To: Patrice Chotard <patrice.chotard.st@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Olivier Clergeaud <olivier.clergeaud@st.com>,
        Lee Jones <lee.jones@linaro.org>,
        Fabio Baltieri <fabio.baltieri@linaro.org>,
        Patrice Chotard <patrice.chotard@st.com>,
        Gabriel Fernandez <gabriel.fernandez@st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 20, 2013 at 4:04 PM,  <patrice.chotard.st@gmail.com> wrote:

> From: Patrice Chotard <patrice.chotard@st.com>
>
> We use the same way to define pin muxing and pin configuration
> than for nomadik. So pickup code from pinctrl_nomadik.c to be
> able to implement pin multiplexing and pin configuration using
> the device tree. Pin configuration uses generic parsing code.
>
> Signed-off-by: Gabriel Fernandez <gabriel.fernandez@st.com>
> Signed-off-by: Patrice Chotard <patrice.chotard@st.com>

Thanks, this v2 version applied.

Yours,
Linus Walleij
