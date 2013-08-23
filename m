Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756178Ab3HWS5c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 14:57:32 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:63930 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755790Ab3HWS5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 14:57:31 -0400
MIME-Version: 1.0
In-Reply-To: <1377257720-15861-2-git-send-email-sachin.kamat@linaro.org>
References: <1377257720-15861-1-git-send-email-sachin.kamat@linaro.org>
	<1377257720-15861-2-git-send-email-sachin.kamat@linaro.org>
Date: Fri, 23 Aug 2013 20:57:31 +0200
Message-ID: <CACRpkdYn5OWctMFYi0DCvPLSqh8MOfoXnpErfLodM4m4ZuNcvg@mail.gmail.com>
Subject: Re: [PATCH 2/2] mfd: db8500-prcmu: Staticize clk_mgt
From: Linus Walleij <linus.walleij@linaro.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 23, 2013 at 1:35 PM, Sachin Kamat <sachin.kamat@linaro.org> wrote:

> clk_mgt is used only in this file. Make it static.
>
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
