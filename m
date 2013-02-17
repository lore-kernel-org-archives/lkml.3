Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349Ab3BQBj2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2013 20:39:28 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:42893 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754265Ab3BQBj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2013 20:39:27 -0500
MIME-Version: 1.0
In-Reply-To: <1360996646.6116.2.camel@phoenix>
References: <1360996576.6116.1.camel@phoenix>
	<1360996646.6116.2.camel@phoenix>
Date: Sun, 17 Feb 2013 09:39:25 +0800
Message-ID: <CAN1soZwZu=in3GBtcssPV0iVCch1wy7CS5tPH3zo_n7EOAny=A@mail.gmail.com>
Subject: Re: [RFT][PATCH 2/3] regulator: 88pm8607: Use enable_is_inverted flag
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

On Sat, Feb 16, 2013 at 2:37 PM, Axel Lin <axel.lin@ingics.com> wrote:
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
>  drivers/regulator/88pm8607.c |   36 ++++--------------------------------
>  1 file changed, 4 insertions(+), 32 deletions(-)
>

Reviewed-by: Haojian Zhuang <haojian.zhuang@gmail.com>
