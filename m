Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932968AbaICPCp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 11:02:45 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:56999 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755013AbaICPCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 11:02:43 -0400
Message-ID: <54072D96.6070906@wwwdotorg.org>
Date: Wed, 03 Sep 2014 09:02:46 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
CC: linux-gpio@vger.kernel.org, Fan Wu <fwu@marvell.com>
Subject: Re: [PATCH] pinctrl: clean up after enable refactoring
References: <1409742329-17411-1-git-send-email-linus.walleij@linaro.org>
In-Reply-To: <1409742329-17411-1-git-send-email-linus.walleij@linaro.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03/2014 05:05 AM, Linus Walleij wrote:
> commit 2243a87d90b42eb38bc281957df3e57c712b5e56
> "pinctrl: avoid duplicated calling enable_pinmux_setting for a pin"
> removed the .disable callback from the struct pinmux_ops,
> making the .enable() callback the only remaining callback.
>
> However .enable() is a bad name as it seems to imply that a
> muxing can also be disabled. Rename the callback to .set_mux()
> and also take this opportunity to clean out any remaining
> mentions of .disable() from the documentation.

Acked-by: Stephen Warren <swarren@nvidia.com>
