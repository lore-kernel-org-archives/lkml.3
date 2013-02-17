Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755377Ab3BQBjv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2013 20:39:51 -0500
Received: from mail-ea0-f173.google.com ([209.85.215.173]:41376 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755157Ab3BQBju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2013 20:39:50 -0500
MIME-Version: 1.0
In-Reply-To: <1360996717.6116.3.camel@phoenix>
References: <1360996576.6116.1.camel@phoenix>
	<1360996717.6116.3.camel@phoenix>
Date: Sun, 17 Feb 2013 09:39:48 +0800
Message-ID: <CAN1soZww41T9WaWPOsLZHzDqquEo_DCeXeqPP9BWbjnJXyZ2GA@mail.gmail.com>
Subject: Re: [RFT][PATCH 3/3] regulator: max8649: Use enable_is_inverted flag
 with regulator_enable_regmap and friends APIs
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "Jett.Zhou" <jtzhou@marvell.com>, Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 16, 2013 at 2:38 PM, Axel Lin <axel.lin@ingics.com> wrote:
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
>  drivers/regulator/max8649.c |   39 ++++++---------------------------------
>  1 file changed, 6 insertions(+), 33 deletions(-)
>

Reviewed-by: Haojian Zhuang <haojian.zhuang@gmail.com>
