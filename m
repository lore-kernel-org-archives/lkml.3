Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661Ab3C0Vsi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 17:48:38 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:48843 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752720Ab3C0Vsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 17:48:35 -0400
MIME-Version: 1.0
In-Reply-To: <1363323196-29628-1-git-send-email-sachin.kamat@linaro.org>
References: <1363323196-29628-1-git-send-email-sachin.kamat@linaro.org>
Date: Wed, 27 Mar 2013 22:48:35 +0100
Message-ID: <CACRpkdYpWV+XcphHMcfCbi=7QQCnQgtmio+u7AvWxWS5g9R71A@mail.gmail.com>
Subject: Re: [PATCH 1/2] pinctrl: generic: Make 'conf_items' static
From: Linus Walleij <linus.walleij@linaro.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 15, 2013 at 5:53 AM, Sachin Kamat <sachin.kamat@linaro.org> wrote:

> 'conf_items' is used only in this file. Silences the below
> sparse warning:
> drivers/pinctrl/pinconf-generic.c:37:24: warning:
> symbol 'conf_items' was not declared. Should it be static?
>
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>

Nice catch! Nice sparseing!
Patch applied!

Thanks,
Linus Walleij
