Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800Ab3IYD34 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 23:29:56 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48083 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754095Ab3IYD3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 23:29:53 -0400
MIME-Version: 1.0
In-Reply-To: <1380058785-18748-1-git-send-email-rklein@nvidia.com>
References: <1380058785-18748-1-git-send-email-rklein@nvidia.com>
Date: Wed, 25 Sep 2013 08:59:52 +0530
Message-ID: <CAKDJKT7gxWhgE3tJSq6vH-WODhy2rFbsbJQgEDSKbzudxBe5zQ@mail.gmail.com>
Subject: Re: [Patch V3] drivers: power: Add support for bq24735 charger
From: Manish Badarkhe <badarkhe.manish@gmail.com>
To: Rhyland Klein <rklein@nvidia.com>
Cc: Anton Vorontsov <anton@enomsg.org>, David Woodhouse <dwmw2@infradead.org>,
        Darbha Sriharsha <dsriharsha@nvidia.com>,
        Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <thierry.reding@gmail.com>, devicetree@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-tegra@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> +       if (gpio_is_valid(charger->pdata->status_gpio)) {
> +               ret = devm_gpio_request(&client->dev,
> +                                       charger->pdata->status_gpio,
> +                                       name);
> +               if (ret)
> +                       dev_err(&client->dev, "Failed GPIO request: %d\n", ret);

This should include GPIO number also to show error with more verbosity.

Regards
Manish Badarkhe
