Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754295AbaDRRbB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 13:31:01 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:57213 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752794AbaDRRa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 13:30:56 -0400
MIME-Version: 1.0
In-Reply-To: <1397757570-19750-5-git-send-email-dianders@chromium.org>
References: <1397757570-19750-1-git-send-email-dianders@chromium.org>
	<1397757570-19750-5-git-send-email-dianders@chromium.org>
Date: Fri, 18 Apr 2014 11:30:55 -0600
X-Google-Sender-Auth: pAaY46_AAVgW7MpMNd2yUFi62IY
Message-ID: <CAPnjgZ1_LAzUMX+K06o7A8uH6RLk59E-3mV30-Yo8YRcwvsJ8A@mail.gmail.com>
Subject: Re: [PATCH 4/7] mfd: cros_ec: spi: Increase cros_ec_spi deadline from
 5ms to 100ms
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

Hi Doug,

On 17 April 2014 11:59, Doug Anderson <dianders@chromium.org> wrote:
> We're adding i2c tunneling to the list of things that goes over
> cros_ec.  i2c tunneling can be slooooooow, so increase our deadline to
> 100ms to account for that.
>
> Signed-off-by: Doug Anderson <dianders@chromium.org>

I believe the EC protocol should be changed on future platforms to
poll for completion of I2C, but in the meantime this patch prevents
failure.

Reviewed-by: Simon Glass <sjg@chromium.org>
