Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964883Ab3CNQ5x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 12:57:53 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:49716 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964808Ab3CNQ5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 12:57:52 -0400
MIME-Version: 1.0
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998F82E488F7@DQHE02.ent.ti.com>
References: <A874F61F95741C4A9BA573A70FE3998F82E488F7@DQHE02.ent.ti.com>
From: Bryan Wu <cooloney@gmail.com>
Date: Thu, 14 Mar 2013 09:57:29 -0700
Message-ID: <CAK5ve-LSnX5WLKTe27xV1QMZskCJFFtpf+szSaddNpxqYKRw9w@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] leds: replace macros with inline functions and
 support camera LED triggers
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 14, 2013 at 4:29 AM, Kim, Milo <Milo.Kim@ti.com> wrote:
> Patch v2
>  (1) LED trigger macros are replaced with inline function in case of
>      !CONFIG_LED_TRIGGERS and !CONFIG_LEDS_TRIGGER_IDE_DISK.
>  (2) Use an inline function when CONFIG_LEDS_TRIGGER_CAMERA is not configured.
>
> Patch v1
>  Initial patch
>

Thanks Milo, I merged these 3 patches!

-Bryan

> Milo(Woogyom) Kim (3):
>   leds: trigger: use inline functions instead of macros
>   leds: add camera LED triggers
>   leds: lm355x, lm3642: support camera LED triggers for flash and torch
>
>  drivers/leds/leds-lm355x.c            |    2 ++
>  drivers/leds/leds-lm3642.c            |    2 ++
>  drivers/leds/trigger/Kconfig          |    8 +++++
>  drivers/leds/trigger/Makefile         |    1 +
>  drivers/leds/trigger/ledtrig-camera.c |   57 +++++++++++++++++++++++++++++++++
>  include/linux/leds.h                  |   33 ++++++++++++-------
>  include/linux/mmc/host.h              |    2 --
>  7 files changed, 92 insertions(+), 13 deletions(-)
>  create mode 100644 drivers/leds/trigger/ledtrig-camera.c
>
> --
> 1.7.9.5
>
>
> Best Regards,
> Milo
>
>
