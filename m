Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756588AbaGIWQ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 18:16:26 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:62131 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755289AbaGIWQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 18:16:24 -0400
MIME-Version: 1.0
In-Reply-To: <1404910216-2170-1-git-send-email-linus.walleij@linaro.org>
References: <1404910216-2170-1-git-send-email-linus.walleij@linaro.org>
Date: Wed, 9 Jul 2014 15:16:24 -0700
Message-ID: <CAJAp7Oi-UH4SUHNw_gHtm=P8EYG3+BsA=hPAsZZWjfG5KCMJeA@mail.gmail.com>
Subject: Re: [PATCH v3] pinctrl: msm: move all qualcomm drivers to subdir
From: Bjorn Andersson <bjorn@kryo.se>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-gpio@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 9, 2014 at 5:50 AM, Linus Walleij <linus.walleij@linaro.org> wrote:
> We have four Qualcomm-related pin control drivers, and now there
> are drivers coming in for the PMICs on these systems, so let's
> create a qcom subdirectory to hold all the Qualcomm stuff.
>
> Cc: Bjorn Andersson <bjorn.andersson@sonymobile.com>
> Cc: Ivan T. Ivanov <iivanov@mm-sol.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

Nice initiative.

Acked-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>
