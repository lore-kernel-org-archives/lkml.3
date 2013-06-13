Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755096Ab3FMFZU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 01:25:20 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:37382 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753667Ab3FMFZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 01:25:18 -0400
MIME-Version: 1.0
In-Reply-To: <1371072668-19027-1-git-send-email-mkl@pengutronix.de>
References: <1371072668-19027-1-git-send-email-mkl@pengutronix.de>
Date: Thu, 13 Jun 2013 10:55:17 +0530
Message-ID: <CAK9yfHywxyju2TbMWTfM7GBjjj8T5SdP8sc1j=VRRPxBesUtxQ@mail.gmail.com>
Subject: Re: [RFC: PATCH] err.h: silence warning when using IS_ERR on void
 __iomem *
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Marc Kleine-Budde <mkl@pengutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de, Thierry Reding <thierry.reding@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13 June 2013 03:01, Marc Kleine-Budde <mkl@pengutronix.de> wrote:
> Commit 75096579c3ac ("lib: devres: Introduce devm_ioremap_resource()")
> introduced devm_ioremap_resource() and encourage to check its return value with
> IS_ERR(). This however leads to the following sparse warnings, as
> devm_ioremap_resource() returns a void __iomem pointer:
>
> drivers/net/can/c_can/c_can_platform.c:205:32: warning: incorrect type in argument 1 (different address spaces)
> drivers/net/can/c_can/c_can_platform.c:205:32:    expected void const *ptr
> drivers/net/can/c_can/c_can_platform.c:205:32:    got unsigned int [noderef] [usertype] <asn:2>*raminit_ctrlreg

CC ing Thierry who has solved this issue some time back.

-- 
With warm regards,
Sachin
