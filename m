Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755172Ab3JHH7L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 03:59:11 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:37089 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752215Ab3JHH7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 03:59:09 -0400
MIME-Version: 1.0
In-Reply-To: <1380370138-3513-7-git-send-email-sachin.kamat@linaro.org>
References: <1380370138-3513-1-git-send-email-sachin.kamat@linaro.org>
	<1380370138-3513-7-git-send-email-sachin.kamat@linaro.org>
Date: Tue, 8 Oct 2013 09:59:08 +0200
Message-ID: <CACRpkdbWDFKuKRqHiaXXvXre61+SoN3Jm-OPKLQPDZELgDOz_A@mail.gmail.com>
Subject: Re: [PATCH 07/11] pinctrl: imx6q: Remove redundant of_match_ptr
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
