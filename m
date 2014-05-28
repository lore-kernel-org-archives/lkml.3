Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753003AbaE1MQb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 08:16:31 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:49897 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751697AbaE1MQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 08:16:30 -0400
MIME-Version: 1.0
In-Reply-To: <1401269165-2996-2-git-send-email-sachin.kamat@linaro.org>
References: <1401269165-2996-1-git-send-email-sachin.kamat@linaro.org>
	<1401269165-2996-2-git-send-email-sachin.kamat@linaro.org>
Date: Wed, 28 May 2014 14:16:30 +0200
Message-ID: <CACRpkdZf23iDt3VMJ_95mHidDuE-wO-pe9h5UyRhP3tmuHXDPA@mail.gmail.com>
Subject: Re: [PATCH 2/2] ARM: ux500: Staticize ab8505_regulators
From: Linus Walleij <linus.walleij@linaro.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Lee Jones <lee.jones@linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2014 at 11:26 AM, Sachin Kamat <sachin.kamat@linaro.org> wrote:

> 'ab8505_regulators' is used only in this file.
>
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>

Patch applied.

Yours,
Linus Walleij
