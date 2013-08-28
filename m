Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755284Ab3H1LQw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 07:16:52 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:45747 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754076Ab3H1LQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 07:16:50 -0400
MIME-Version: 1.0
In-Reply-To: <1377239273.14131.0.camel@phoenix>
References: <1377239273.14131.0.camel@phoenix>
Date: Wed, 28 Aug 2013 13:16:49 +0200
Message-ID: <CACRpkdbt+=88KD=5w8n9UM8QX-tApD4yPYrA9fdL7yZEKX4+tg@mail.gmail.com>
Subject: Re: [PATCH 1/2] pinctrl: rockchip: Remove of_match_ptr macro for DT
 only driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 23, 2013 at 8:27 AM, Axel Lin <axel.lin@ingics.com> wrote:

> This is a DT only driver and rockchip_pinctrl_dt_match is always compiled in.
> Thus remove of_match_ptr macro.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

Patch applied, thanks!

Yours,
Linus Walleij
