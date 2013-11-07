Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751983Ab3KGLux (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 06:50:53 -0500
Received: from mail-oa0-f44.google.com ([209.85.219.44]:52600 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923Ab3KGLuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 06:50:50 -0500
MIME-Version: 1.0
In-Reply-To: <2713030.RoDxNQo0oz@amdc1227>
References: <1381869563-16083-1-git-send-email-grant.likely@linaro.org>
	<20131104050455.GA3651@quad.lixom.net>
	<2177804.l4VGDTRFDu@amdc1227>
	<2713030.RoDxNQo0oz@amdc1227>
Date: Thu, 7 Nov 2013 17:20:49 +0530
Message-ID: <CAK9yfHxgbyaucmJ34fj0bu-4amO4OPs-RjzBRQWcGDwTKDr=mA@mail.gmail.com>
Subject: Re: [PATCH 1/2] of: irq: Fix interrupt-map entry matching
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Tomasz Figa <t.figa@samsung.com>
Cc: Olof Johansson <olof@lixom.net>, Grant Likely <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kevin Hilman <khilman@linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5 November 2013 20:51, Tomasz Figa <t.figa@samsung.com> wrote:
> This patch fixes interrupt-map entry matching code to properly match all
> specifier cells with interrupt map entries.
>
> Signed-off-by: Tomasz Figa <t.figa@samsung.com>

Tested on Origen and Arndale boards. Works fine.

Tested-by: Sachin Kamat <sachin.kamat@linaro.org>

-- 
With warm regards,
Sachin
