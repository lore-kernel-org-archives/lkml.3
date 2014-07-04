Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761088AbaGDXQ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 19:16:26 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:52163 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760222AbaGDXQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 19:16:24 -0400
MIME-Version: 1.0
In-Reply-To: <20140611081513.GA29572@mwanda>
References: <20140611081513.GA29572@mwanda>
Date: Sat, 5 Jul 2014 01:16:23 +0200
Message-ID: <CACRpkdbPEY=wggCEd36FsZF2v9srCypjovwJFuh4Yu46dB6tgA@mail.gmail.com>
Subject: Re: [patch] pinctrl: berlin: fix an error code in berlin_pinctrl_probe()
From: Linus Walleij <linus.walleij@linaro.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Antoine Tenart <antoine.tenart@free-electrons.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2014 at 10:15 AM, Dan Carpenter
<dan.carpenter@oracle.com> wrote:

> We are returning success here because PTR_ERR(NULL) is zero.  We should
> be returning -ENODEV.
>
> Fixes: 3de68d331c24 ('pinctrl: berlin: add the core pinctrl driver for Marvell Berlin SoCs')
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Patch applied for fixes!

Yours,
Linus Walleij
