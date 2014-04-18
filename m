Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754723AbaDRR3a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 13:29:30 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:44698 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753896AbaDRR3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 13:29:24 -0400
MIME-Version: 1.0
In-Reply-To: <1397757570-19750-6-git-send-email-dianders@chromium.org>
References: <1397757570-19750-1-git-send-email-dianders@chromium.org>
	<1397757570-19750-6-git-send-email-dianders@chromium.org>
Date: Fri, 18 Apr 2014 11:29:23 -0600
X-Google-Sender-Auth: 4fYm0UrAo5P8dRreLDWh8fqawko
Message-ID: <CAPnjgZ1hYvXp_OGPsMZGjg+15GSeE59n8XfgvRRQpP2Oa5bJJw@mail.gmail.com>
Subject: Re: [PATCH 5/7] mfd: cros_ec: Sync to the latest cros_ec_commands.h
 from EC sources
From: Simon Glass <sjg@chromium.org>
To: Doug Anderson <dianders@chromium.org>
Cc: Lee Jones <lee.jones@linaro.org>, Stephen Warren <swarren@nvidia.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        Andrew Bresticker <abrestic@chromium.org>,
        Dylan Reid <dgreid@chromium.org>, Olof Johansson <olof@lixom.net>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Bill Richardson <wfrichar@chromium.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        lk <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17 April 2014 11:59, Doug Anderson <dianders@chromium.org> wrote:
> From: Bill Richardson <wfrichar@chromium.org>
>
> This just updates include/linux/mfd/cros_ec_commands.h to match the
> latest EC version (which is the One True Source for such things).  See
> <https://chromium.googlesource.com/chromiumos/platform/ec>
>
> [dianders: took today's ToT version from the Chromium OS EC; deleted
> references to cros_ec_dev and cros_ec_lpc since those aren't upstream
> yet]
>
> Signed-off-by: Bill Richardson <wfrichar@chromium.org>
> Signed-off-by: Doug Anderson <dianders@chromium.org>

Reviewed-by: Simon Glass <sjg@chromium.org>
