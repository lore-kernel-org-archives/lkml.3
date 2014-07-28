Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751755AbaG1STr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 14:19:47 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:50557 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036AbaG1STq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 14:19:46 -0400
MIME-Version: 1.0
In-Reply-To: <20140728122211.GS17528@sirena.org.uk>
References: <1406547718-21498-1-git-send-email-nicoleotsuka@gmail.com>
	<20140728122211.GS17528@sirena.org.uk>
Date: Mon, 28 Jul 2014 15:19:43 -0300
Message-ID: <CAOMZO5DgE9RjC9MG7FbGPKwsgxunntw70W6Sj8WQKFYG+j8BsA@mail.gmail.com>
Subject: Re: [alsa-devel] [PATCH v2] ASoC: wm8962: Let CODEC driver enable and
 disable its own MCLK
From: Fabio Estevam <festevam@gmail.com>
To: Mark Brown <broonie@kernel.org>
Cc: Nicolin Chen <nicoleotsuka@gmail.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        patches@opensource.wolfsonmicro.com, b02247@freescale.com,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Nicolin Chen <b42378@freescale.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nicolin,

On Mon, Jul 28, 2014 at 9:22 AM, Mark Brown <broonie@kernel.org> wrote:
> On Mon, Jul 28, 2014 at 07:41:58PM +0800, Nicolin Chen wrote:
>
>> +     pdata->mclk = devm_clk_get(&i2c->dev, NULL);
>> +
>
> This is broken for deferred probe.

You can take a look at sgtl5000 to see how we handle deferred probe in
devm_clk_get().
