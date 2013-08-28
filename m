Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754772Ab3H1UKT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 16:10:19 -0400
Received: from mail-vc0-f173.google.com ([209.85.220.173]:49216 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971Ab3H1UKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 16:10:17 -0400
MIME-Version: 1.0
In-Reply-To: <20130828185459.GV30088@pengutronix.de>
References: <1377657163-6606-1-git-send-email-festevam@gmail.com>
	<20130828052758.GQ30088@pengutronix.de>
	<CAOMZO5BiE7tqja9p51gOGEwtWsKjyX23qZ3=ewyuubMwsgXcLA@mail.gmail.com>
	<20130828185459.GV30088@pengutronix.de>
Date: Wed, 28 Aug 2013 17:10:16 -0300
Message-ID: <CAOMZO5CuGAH+5+8cE7tjzZTXhLbFxMRt13mhimuBLJkRQz6+7Q@mail.gmail.com>
Subject: Re: [PATCH] imx-drm: Fix probe failure
From: Fabio Estevam <festevam@gmail.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Shawn Guo <shawn.guo@linaro.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Fabio Estevam <fabio.estevam@freescale.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 28, 2013 at 3:54 PM, Sascha Hauer <s.hauer@pengutronix.de> wrote:

> Do the open/close callbacks work?

The 'open' callback maps to the generic 'drm_open', so we cannot use it.

Shouldn't we rely on the refcount done by the drm core instead of
doing this manually in imx-drm?
