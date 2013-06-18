Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932204Ab3FROzR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 10:55:17 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:59594 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756025Ab3FROzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 10:55:13 -0400
MIME-Version: 1.0
In-Reply-To: <1371546267-22093-4-git-send-email-sachin.kamat@linaro.org>
References: <1371546267-22093-1-git-send-email-sachin.kamat@linaro.org>
	<1371546267-22093-4-git-send-email-sachin.kamat@linaro.org>
Date: Tue, 18 Jun 2013 16:55:12 +0200
Message-ID: <CACRpkdZxpm_C8K2Rn3hV=kqAK2p0mip4f1Rx=B9+2g7NXpCd=w@mail.gmail.com>
Subject: Re: [PATCH 4/4] pinctrl: Staticize local symbols
From: Linus Walleij <linus.walleij@linaro.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Patrice Chotard <patrice.chotard@st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 18, 2013 at 11:04 AM, Sachin Kamat <sachin.kamat@linaro.org> wrote:

> Symbols referenced only in this file are made static.
>
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> Cc: Patrice Chotard <patrice.chotard@st.com>

Excellent observation Sachin, patch applied.

Yours,
Linus Walleij
