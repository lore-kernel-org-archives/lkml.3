Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756204Ab3JKOUh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 10:20:37 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:45721 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752705Ab3JKOUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 10:20:35 -0400
MIME-Version: 1.0
In-Reply-To: <1380916902-23791-4-git-send-email-david.a.cohen@linux.intel.com>
References: <1380916902-23791-1-git-send-email-david.a.cohen@linux.intel.com>
	<1380916902-23791-4-git-send-email-david.a.cohen@linux.intel.com>
Date: Fri, 11 Oct 2013 16:20:35 +0200
Message-ID: <CACRpkdb+_58RkuM82JptvgozCeRYv7LAAFu4vDZ0WNZv9twVTQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] gpio-intel-mid: update prefixes and names from
 langwell to intel-mid
From: Linus Walleij <linus.walleij@linaro.org>
To: David Cohen <david.a.cohen@linux.intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 4, 2013 at 10:01 PM, David Cohen
<david.a.cohen@linux.intel.com> wrote:

> After file was renamed from gpio-langwell to gpio-intel-mid, this patch
> updates the variables, functions and structs to be based on intel-mid
> instead of langwell.
>
> There is no function change.
>
> Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>

Some call this renaming stuff "churn" but I'm actually quite
happy with the developers having the right labels on things,
so patch applied.

Yours,
Linus Walleij
