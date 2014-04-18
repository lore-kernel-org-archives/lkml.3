Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554AbaDRR1E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 13:27:04 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:62167 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753048AbaDRR06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 13:26:58 -0400
MIME-Version: 1.0
In-Reply-To: <1397757570-19750-4-git-send-email-dianders@chromium.org>
References: <1397757570-19750-1-git-send-email-dianders@chromium.org>
	<1397757570-19750-4-git-send-email-dianders@chromium.org>
Date: Fri, 18 Apr 2014 11:26:56 -0600
X-Google-Sender-Auth: Y0Dhi0u0RGgQjJVZ87fj_rX6ELA
Message-ID: <CAPnjgZ2J8V=ZtivYZJOepBi_6h7VEhZ+R-XjjT+yA0YeW9+Tqw@mail.gmail.com>
Subject: Re: [PATCH 3/7] mfd: cros_ec: spi: Make the cros_ec_spi timeout more reliable
From: Simon Glass <sjg@chromium.org>
To: Doug Anderson <dianders@chromium.org>
Cc: Lee Jones <lee.jones@linaro.org>, Stephen Warren <swarren@nvidia.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        Andrew Bresticker <abrestic@chromium.org>,
        Dylan Reid <dgreid@chromium.org>, Olof Johansson <olof@lixom.net>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        lk <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17 April 2014 11:59, Doug Anderson <dianders@chromium.org> wrote:
> The cros_ec_spi transfer had two problems with its timeout code:
>
> 1. It looked at the timeout even in the case that it found valid data.
> 2. If the cros_ec_spi code got switched out for a while, it's possible
>    it could get a timeout after a single loop.  Let's be paranoid and
>    make sure we do one last transfer after the timeout expires.
>
> Signed-off-by: Doug Anderson <dianders@chromium.org>

Reviewed-by: Simon Glass <sjg@chromium.org>
