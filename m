Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756164Ab3HWS5F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 14:57:05 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:32994 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755790Ab3HWS5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 14:57:03 -0400
MIME-Version: 1.0
In-Reply-To: <1377257720-15861-1-git-send-email-sachin.kamat@linaro.org>
References: <1377257720-15861-1-git-send-email-sachin.kamat@linaro.org>
Date: Fri, 23 Aug 2013 20:57:02 +0200
Message-ID: <CACRpkdZ6DK14H2cHTD6rwW93zsDU+a9zJ=K1Zz4HE5-DcEXT7g@mail.gmail.com>
Subject: Re: [PATCH 1/2] mfd: db8500-prcmu: Use ANSI function declaration
From: Linus Walleij <linus.walleij@linaro.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 23, 2013 at 1:35 PM, Sachin Kamat <sachin.kamat@linaro.org> wrote:

> Silences the following warning:
> drivers/mfd/db8500-prcmu.c:2322:25: warning:
> non-ANSI function declaration of function 'prcmu_ac_sleep_req'
>
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
