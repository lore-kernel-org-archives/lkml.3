Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754944Ab3JHH4I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 03:56:08 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:37745 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045Ab3JHH4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 03:56:06 -0400
MIME-Version: 1.0
In-Reply-To: <1380370138-3513-3-git-send-email-sachin.kamat@linaro.org>
References: <1380370138-3513-1-git-send-email-sachin.kamat@linaro.org>
	<1380370138-3513-3-git-send-email-sachin.kamat@linaro.org>
Date: Tue, 8 Oct 2013 09:56:05 +0200
Message-ID: <CACRpkda62m9pRyJRNsytJY08d+YR-vv+-vLc3MCE1FWk7DSU-Q@mail.gmail.com>
Subject: Re: [PATCH 03/11] pinctrl: imx35: Remove redundant of_match_ptr
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
