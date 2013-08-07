Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933065Ab3HGSyT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 14:54:19 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:41882 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756956Ab3HGSyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 14:54:15 -0400
MIME-Version: 1.0
In-Reply-To: <1375071776-29037-2-git-send-email-sachin.kamat@linaro.org>
References: <1375071776-29037-1-git-send-email-sachin.kamat@linaro.org>
	<1375071776-29037-2-git-send-email-sachin.kamat@linaro.org>
Date: Wed, 7 Aug 2013 20:54:14 +0200
Message-ID: <CACRpkdYDtyaRwXrdGofUs3h0wJpHyrkEYRiV7n9aCv=7b6bSKA@mail.gmail.com>
Subject: Re: [PATCH 2/2] pinctrl: st: Staticize local symbols
From: Linus Walleij <linus.walleij@linaro.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 29, 2013 at 6:22 AM, Sachin Kamat <sachin.kamat@linaro.org> wrote:

> Symbols used only in this file are made static.
>
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>

Patch applied with Srinivas ACK.

Yours,
Linus Walleij
