Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754832Ab3JHHzJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 03:55:09 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:64751 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885Ab3JHHzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 03:55:08 -0400
MIME-Version: 1.0
In-Reply-To: <1380370138-3513-2-git-send-email-sachin.kamat@linaro.org>
References: <1380370138-3513-1-git-send-email-sachin.kamat@linaro.org>
	<1380370138-3513-2-git-send-email-sachin.kamat@linaro.org>
Date: Tue, 8 Oct 2013 09:55:07 +0200
Message-ID: <CACRpkdb3uuAZboHO-7SiUsH7nrMW=Ym2jb62Kn+8D5FnK+wqdQ@mail.gmail.com>
Subject: Re: [PATCH 02/11] pinctrl: exynos5440: Remove redundant of_match_ptr
From: Linus Walleij <linus.walleij@linaro.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 28, 2013 at 2:08 PM, Sachin Kamat <sachin.kamat@linaro.org> wrote:

> The data structure of_match_ptr() protects is always compiled in.
> Hence of_match_ptr() is not needed.
>
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>

Patch applied.

Yours,
Linus Walleij
