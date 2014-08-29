Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752228AbaH2E6n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 00:58:43 -0400
Received: from mail-oi0-f47.google.com ([209.85.218.47]:35977 "EHLO
	mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173AbaH2E6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 00:58:41 -0400
MIME-Version: 1.0
In-Reply-To: <1407765791-3887-1-git-send-email-kiran.padwal21@gmail.com>
References: <1407765791-3887-1-git-send-email-kiran.padwal21@gmail.com>
Date: Fri, 29 Aug 2014 06:58:40 +0200
Message-ID: <CACRpkdYS3hnuShBQ-=fgY+A3XSsy9mUFfNq0mahOhUt6oNUwfg@mail.gmail.com>
Subject: Re: [PATCH 2/3] pinctrl: tegra20: Make of_device_id array const
From: Linus Walleij <linus.walleij@linaro.org>
To: Kiran Padwal <kiran.padwal21@gmail.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2014 at 4:03 PM, Kiran Padwal <kiran.padwal21@gmail.com> wrote:

> Make of_device_id array const, because all OF functions handle it as const.
>
> Signed-off-by: Kiran Padwal <kiran.padwal21@gmail.com>

Applied and squashed.

Yours,
Linus Walleij
