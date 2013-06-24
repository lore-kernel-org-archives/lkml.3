Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752894Ab3FXLhm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 07:37:42 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:35789 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979Ab3FXLhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 07:37:41 -0400
MIME-Version: 1.0
In-Reply-To: <1371737145-27662-5-git-send-email-patrice.chotard.st@gmail.com>
References: <1371737145-27662-1-git-send-email-patrice.chotard.st@gmail.com>
	<1371737145-27662-5-git-send-email-patrice.chotard.st@gmail.com>
Date: Mon, 24 Jun 2013 13:37:41 +0200
Message-ID: <CACRpkdZm-A-CVU+Lf=74HR71gH2fwTsigv7gJRGTS2seL=Vs=A@mail.gmail.com>
Subject: Re: [PATCH v2 4/4] pinctrl: abx500: rework error path
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
> At several places, return value was not tested
> and error output was missing.
>
> Signed-off-by: Patrice Chotard <patrice.chotard@st.com>

This looks fine, but does not apply since I didn't accept patch 1/4.

Please resend 1/4 and this 4/4 after fixing up 1/4.

(You can rebase onto devel if you want to be 100% sure it applies.)

Yours,
Linus Walleij
