Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752950AbaH2FKb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 01:10:31 -0400
Received: from mail-oi0-f44.google.com ([209.85.218.44]:50674 "EHLO
	mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141AbaH2FKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 01:10:30 -0400
MIME-Version: 1.0
In-Reply-To: <1407765741-3846-1-git-send-email-kiran.padwal21@gmail.com>
References: <1407765741-3846-1-git-send-email-kiran.padwal21@gmail.com>
Date: Fri, 29 Aug 2014 07:10:29 +0200
Message-ID: <CACRpkdYd_eVp82zj=5FsM6mVybvv4rC5=sm4tratmdyCzefxYQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] pinctrl: tegra124: Make of_device_id array const
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

On Mon, Aug 11, 2014 at 4:02 PM, Kiran Padwal <kiran.padwal21@gmail.com> wrote:

> Make of_device_id array const, because all OF functions handle it as const.
>
> Signed-off-by: Kiran Padwal <kiran.padwal21@gmail.com>

Applied and squashed.

Yours,
Linus Walleij
