Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691Ab3FROxS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 10:53:18 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:40868 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752964Ab3FROxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 10:53:16 -0400
MIME-Version: 1.0
In-Reply-To: <1371546267-22093-3-git-send-email-sachin.kamat@linaro.org>
References: <1371546267-22093-1-git-send-email-sachin.kamat@linaro.org>
	<1371546267-22093-3-git-send-email-sachin.kamat@linaro.org>
Date: Tue, 18 Jun 2013 16:53:15 +0200
Message-ID: <CACRpkdZ5SjTnaj+-2_sctmhORYD+4trbB4TJVyYG81oEAo8MgA@mail.gmail.com>
Subject: Re: [PATCH 3/4] pinctrl: spear/plgpio: Staticize spear310_o2p
From: Linus Walleij <linus.walleij@linaro.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 18, 2013 at 11:04 AM, Sachin Kamat <sachin.kamat@linaro.org> wrote:

> 'spear310_o2p' is referenced only in this file.
>
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> Cc: Viresh Kumar <viresh.kumar@linaro.org>

Patch applied with Viresh's ACK.

Thanks,
Linus Walleij
