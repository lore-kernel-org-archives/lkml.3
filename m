Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753288AbaJ1P3k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 11:29:40 -0400
Received: from mail-ig0-f171.google.com ([209.85.213.171]:50558 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892AbaJ1P3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 11:29:39 -0400
MIME-Version: 1.0
In-Reply-To: <1413792260-4265-2-git-send-email-antoine.tenart@free-electrons.com>
References: <1413792260-4265-1-git-send-email-antoine.tenart@free-electrons.com>
	<1413792260-4265-2-git-send-email-antoine.tenart@free-electrons.com>
Date: Tue, 28 Oct 2014 16:29:38 +0100
Message-ID: <CACRpkdZbTXWP34nx8eeAd_BpPuwSspAUZbMv2WRCvaQURiHdfQ@mail.gmail.com>
Subject: Re: [PATCH 1/4] Documentation: bindings: pinctrl: document the
 generic groups property
From: Linus Walleij <linus.walleij@linaro.org>
To: Antoine Tenart <antoine.tenart@free-electrons.com>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20, 2014 at 10:04 AM, Antoine Tenart
<antoine.tenart@free-electrons.com> wrote:

> Group-based drivers use a groups property to define on which groups a
> mux function is applied to. Document it.
>
> Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>

This is already documented but under another heading.

This section was to be for pin config, we now have a separate
section for pin muxing.

Yours,
Linus Walleij
