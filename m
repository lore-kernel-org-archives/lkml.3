Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527AbaGHIZ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 04:25:56 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:63343 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927AbaGHIZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 04:25:54 -0400
MIME-Version: 1.0
In-Reply-To: <1404193516-4384-4-git-send-email-acourbot@nvidia.com>
References: <1404193516-4384-1-git-send-email-acourbot@nvidia.com>
	<1404193516-4384-4-git-send-email-acourbot@nvidia.com>
Date: Tue, 8 Jul 2014 10:25:53 +0200
Message-ID: <CACRpkdYyqNJm9Eoi7uhMKdZt37LVEK+bhWNbuEVfXuQya8BmDw@mail.gmail.com>
Subject: Re: [RFC 3/3] gpio: move integer GPIO support to its own file
From: Linus Walleij <linus.walleij@linaro.org>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 1, 2014 at 7:45 AM, Alexandre Courbot <acourbot@nvidia.com> wrote:

> The old integer GPIO interface is, in effect, a privileged user of the
> gpiod interface. Reflect this fact further by moving legacy GPIO support
> into its own source file. This makes the code clearer and will allow us
> to disable legacy GPIO support in the (far) future.
>
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>

Patch applied.

Yours,
Linus Walleij
