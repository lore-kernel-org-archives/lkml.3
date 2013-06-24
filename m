Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751621Ab3FXNSB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 09:18:01 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:37014 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923Ab3FXNSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 09:18:00 -0400
MIME-Version: 1.0
In-Reply-To: <1372077706-13008-2-git-send-email-patrice.chotard.st@gmail.com>
References: <1372077706-13008-1-git-send-email-patrice.chotard.st@gmail.com>
	<1372077706-13008-2-git-send-email-patrice.chotard.st@gmail.com>
Date: Mon, 24 Jun 2013 15:17:59 +0200
Message-ID: <CACRpkda4PmvrmbFkKOJOdxC0TgzdGrMNtD_fvrdwDoN9+1OOfw@mail.gmail.com>
Subject: Re: [PATCH v3 4/4] pinctrl: abx500: rework error path
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

On Mon, Jun 24, 2013 at 2:41 PM,  <patrice.chotard.st@gmail.com> wrote:

> From: Patrice Chotard <patrice.chotard@st.com>
>
> At several places, return value was not tested
> and error output was missing.
>
> Signed-off-by: Patrice Chotard <patrice.chotard@st.com>

Patch applied.

Yours,
Linus Walleij
