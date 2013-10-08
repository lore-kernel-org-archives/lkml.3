Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754769Ab3JHIGI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 04:06:08 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:32791 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143Ab3JHIGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 04:06:03 -0400
MIME-Version: 1.0
In-Reply-To: <1380370138-3513-11-git-send-email-sachin.kamat@linaro.org>
References: <1380370138-3513-1-git-send-email-sachin.kamat@linaro.org>
	<1380370138-3513-11-git-send-email-sachin.kamat@linaro.org>
Date: Tue, 8 Oct 2013 10:06:03 +0200
Message-ID: <CACRpkdYr5auasYPCiDniVQZyH7vN+EVrfTMnwuoAZyibizxG0Q@mail.gmail.com>
Subject: Re: [PATCH 11/11] pinctrl: plgpio: Remove redundant of_match_ptr
From: Linus Walleij <linus.walleij@linaro.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 28, 2013 at 2:08 PM, Sachin Kamat <sachin.kamat@linaro.org> wrote:

> The data structure of_match_ptr() protects is always compiled in.
> Hence of_match_ptr() is not needed.
>
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> Cc: Viresh Kumar <viresh.kumar@linaro.org>

I have applied this as well, and after that I squashed all 11 commits into
one.

I think these 11 patches should have been one from the beginning
but it's quicker for me to simply squash them than to ask you to
resubmit a squashed patch.

Yours,
Linus Walleij
