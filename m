Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751603Ab3KBERU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Nov 2013 00:17:20 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:46911 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975Ab3KBEQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Nov 2013 00:16:57 -0400
MIME-Version: 1.0
In-Reply-To: <20131101185401.B298FC40868@trevor.secretlab.ca>
References: <1381869563-16083-1-git-send-email-grant.likely@linaro.org>
	<1381869563-16083-5-git-send-email-grant.likely@linaro.org>
	<CAOesGMj03kgJXttm80pHvPYeqg5hOaeOJAJ4DA8tf5LxqdArrQ@mail.gmail.com>
	<CACxGe6uE+KvycQq3XBavRcvprff6PhBaxX54W_Cb1cfuVpMXvQ@mail.gmail.com>
	<20131031185714.GA12646@quad.lixom.net>
	<20131101175317.A812AC40868@trevor.secretlab.ca>
	<20131101185401.B298FC40868@trevor.secretlab.ca>
Date: Sat, 2 Nov 2013 12:16:56 +0800
Message-ID: <CACVXFVN-Vk9k=jceT1iR2nfSNvHQR5MAtrb+vjw9QwcWnn9CVw@mail.gmail.com>
Subject: Re: [RFC 4/9] of/irq: Refactor interrupt-map parsing
From: Ming Lei <tom.leiming@gmail.com>
To: Grant Likely <grant.likely@linaro.org>
Cc: Olof Johansson <olof@lixom.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kevin Hilman <khilman@linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 2, 2013 at 2:54 AM, Grant Likely <grant.likely@linaro.org> wrote:
>
> That one was broken. Try this instead.
>
> From bcbffc3d16f49451ef505dc021480aa061465a15 Mon Sep 17 00:00:00 2001
> From: Grant Likely <grant.likely@linaro.org>
> Date: Fri, 1 Nov 2013 10:50:50 -0700
> Subject: [PATCH] of: Fixup interrupt parsing failure.
>
> Signed-off-by: Grant Likely <grant.likely@linaro.org>
> ---
>  drivers/of/irq.c | 24 ++++++++++++------------
>  1 file changed, 12 insertions(+), 12 deletions(-)

This one does fix boot hanging on Arndale board.

Tested-by: Ming Lei <tom.leiming@gmail.com>

Thanks,
-- 
Ming Lei
