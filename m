Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932160Ab3FROwG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 10:52:06 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:45209 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753312Ab3FROwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 10:52:03 -0400
MIME-Version: 1.0
In-Reply-To: <1371546267-22093-2-git-send-email-sachin.kamat@linaro.org>
References: <1371546267-22093-1-git-send-email-sachin.kamat@linaro.org>
	<1371546267-22093-2-git-send-email-sachin.kamat@linaro.org>
Date: Tue, 18 Jun 2013 16:52:02 +0200
Message-ID: <CACRpkdaTe1fXauRCWOLKWBGWK5uNUWSk4bkWRdSWPHLVH7Zf9A@mail.gmail.com>
Subject: Re: [PATCH 2/4] pinctrl: nomadik: Staticize local symbols
From: Linus Walleij <linus.walleij@linaro.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 18, 2013 at 11:04 AM, Sachin Kamat <sachin.kamat@linaro.org> wrote:

> Some symbols referenced only in this file are made static.
>
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>

Patch applied.

Yours,
Linus Walleij
