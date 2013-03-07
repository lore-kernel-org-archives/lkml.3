Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932484Ab3CGEO4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 23:14:56 -0500
Received: from mail-ia0-f182.google.com ([209.85.210.182]:56511 "EHLO
	mail-ia0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932321Ab3CGEOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 23:14:53 -0500
MIME-Version: 1.0
In-Reply-To: <006301ce195c$7dee06c0$79ca1440$%han@samsung.com>
References: <006301ce195c$7dee06c0$79ca1440$%han@samsung.com>
Date: Thu, 7 Mar 2013 05:14:52 +0100
Message-ID: <CACRpkdbh_AZXfqxK0QvxLvhsjsbQoyQWWCwZQNVYboVmq3i6Dw@mail.gmail.com>
Subject: Re: [PATCH 1/3] mfd: ab3100-otp: use module_platform_driver_probe()
From: Linus Walleij <linus.walleij@linaro.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 5, 2013 at 5:47 AM, Jingoo Han <jg1.han@samsung.com> wrote:

> This patch uses module_platform_driver_probe() macro which makes
> the code smaller and simpler.
>
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
