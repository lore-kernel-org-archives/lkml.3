Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752068AbaKCNZc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 08:25:32 -0500
Received: from mail-ie0-f173.google.com ([209.85.223.173]:57390 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175AbaKCNZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 08:25:29 -0500
MIME-Version: 1.0
In-Reply-To: <20141030194839.GB6764@kwain>
References: <1413792260-4265-1-git-send-email-antoine.tenart@free-electrons.com>
	<1413792260-4265-3-git-send-email-antoine.tenart@free-electrons.com>
	<CACRpkdaPPcUkWrQ8G19igEdDGCXGUGd=utFzny54oRpZ=UNuYA@mail.gmail.com>
	<20141030194839.GB6764@kwain>
Date: Mon, 3 Nov 2014 14:25:28 +0100
Message-ID: <CACRpkdbka+_=vd0uqoQM9c=Dy_DWcEersWAV5jvk2skKufjudw@mail.gmail.com>
Subject: Re: [PATCH 2/4] pinctrl: add helpers for group based drivers
From: Linus Walleij <linus.walleij@linaro.org>
To: Antoine Tenart <antoine.tenart@free-electrons.com>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2014 at 8:48 PM, Antoine Tenart
<antoine.tenart@free-electrons.com> wrote:

> Maybe the of_pinctrl_utils_node_is_mux/config() solution is more
> appropriate to avoid having a confusing function. Plus we would have a
> dedicated of_pinctrl_utils_read_pins() function.
>
> I think I prefer the second solution because it could avoid some
> confusion and the logic would stay in the pinctrl core functions.
>
> I'll cook up a new version if the of_pinctrl_utils_node_is_mux/config()
> is okay with you.

I'm following your idea and I agree. Let's see how that
looks.

Yours,
Linus Walleij
