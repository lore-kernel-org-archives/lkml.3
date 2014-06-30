Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209AbaF3Tg1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 15:36:27 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:58350 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752634AbaF3TgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 15:36:25 -0400
MIME-Version: 1.0
In-Reply-To: <1403898973-19571-3-git-send-email-dianders@chromium.org>
References: <1403898973-19571-1-git-send-email-dianders@chromium.org>
	<1403898973-19571-3-git-send-email-dianders@chromium.org>
Date: Mon, 30 Jun 2014 12:36:24 -0700
X-Google-Sender-Auth: froyutiU7OC_EhfV-1ej4Ttj468
Message-ID: <CAPnjgZ23fmSBaXSwwUby96C00-RgkH9EG8B=cVLV3fSgq5tVVg@mail.gmail.com>
Subject: Re: [PATCH 2/3] mfd: cros_ec: Use the proper size when looking at the
 cros_ec_i2c result
From: Simon Glass <sjg@chromium.org>
To: Doug Anderson <dianders@chromium.org>
Cc: Lee Jones <lee.jones@linaro.org>, Wolfram Sang <wsa@the-dreams.de>,
        Mark Brown <broonie@kernel.org>,
        Vincent Palatin <vpalatin@chromium.org>,
        Bill Richardson <wfrichar@chromium.org>,
        Randall Spangler <rspangler@chromium.org>,
        =?UTF-8?Q?Andreas_F=C3=A4rber?= <afaerber@suse.de>,
        stephan@synkhronix.com, Olof Johansson <olof@lixom.net>,
        Samuel Ortiz <sameo@linux.intel.com>,
        lk <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 June 2014 12:56, Doug Anderson <dianders@chromium.org> wrote:
> We know how many bytes the EC should be sending us (which is also the
> number of bytes transferred) and also how many bytes the EC actually
> wanted to send to us.  When computing the checksum and copying back
> data let's make sure we take the lesser of the two of those.  We'll
> also complain if the EC tried to send us too many bytes.  The EC
> sending us too few bytes is legit for when we send the EC an invalid
> command.
>
> This is based on similar code in cros_ec_spi.
>
> Signed-off-by: Doug Anderson <dianders@chromium.org>

Reviewed-by: Simon Glass <sjg@chromium.org>
