Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754682AbaDRR21 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 13:28:27 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:42269 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752982AbaDRR2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 13:28:17 -0400
MIME-Version: 1.0
In-Reply-To: <1397757570-19750-3-git-send-email-dianders@chromium.org>
References: <1397757570-19750-1-git-send-email-dianders@chromium.org>
	<1397757570-19750-3-git-send-email-dianders@chromium.org>
Date: Fri, 18 Apr 2014 11:28:16 -0600
X-Google-Sender-Auth: 6Jk4DySKO4CmBRxpBDSHmB_CG48
Message-ID: <CAPnjgZ034FrVVphJCmX5jZE8LeWOEBjsH7M=2C_meM0fMss1NA@mail.gmail.com>
Subject: Re: [PATCH 2/7] mfd: cros_ec: spi: Add mutex to cros_ec_spi
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
> The main transfer function for cros_ec_spi can be called by more than
> one client at a time.  Make sure that those clients don't stomp on
> each other by locking the bus for the duration of the transfer
> function.

Is there no lock at the cros_ec layer?

Regards,
Simon
