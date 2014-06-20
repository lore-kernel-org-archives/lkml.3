Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933381AbaFTDk6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 23:40:58 -0400
Received: from mail-qg0-f48.google.com ([209.85.192.48]:55610 "EHLO
	mail-qg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756143AbaFTDk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 23:40:56 -0400
MIME-Version: 1.0
In-Reply-To: <1403115247-8853-6-git-send-email-dianders@chromium.org>
References: <1403115247-8853-1-git-send-email-dianders@chromium.org>
	<1403115247-8853-6-git-send-email-dianders@chromium.org>
Date: Thu, 19 Jun 2014 21:40:55 -0600
X-Google-Sender-Auth: bysbdCxYg6wqbCHAeNBHpnJn4Gk
Message-ID: <CAPnjgZ0VfWx6EFrqPZ71OCr7K+fBQ0STBYAbXPTaL4bsbQ3qow@mail.gmail.com>
Subject: Re: [PATCH v2 05/10] mfd: cros_ec: Use struct cros_ec_command to
 communicate with the EC
From: Simon Glass <sjg@chromium.org>
To: Doug Anderson <dianders@chromium.org>
Cc: Lee Jones <lee.jones@linaro.org>,
        Andrew Bresticker <abrestic@chromium.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Olof Johansson <olof@lixom.net>, Sonny Rao <sonnyrao@chromium.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Bill Richardson <wfrichar@chromium.org>,
        Wolfram Sang <wsa@the-dreams.de>, Mark Brown <broonie@kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        lk <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18 June 2014 12:14, Doug Anderson <dianders@chromium.org> wrote:
> From: Bill Richardson <wfrichar@chromium.org>
>
> This is some internal structure reorganization / renaming to prepare
> for future patches that will add a userspace API to cros_ec.  There
> should be no visible changes.
>
> Signed-off-by: Bill Richardson <wfrichar@chromium.org>
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> Acked-by: Lee Jones <lee.jones@linaro.org>

Reviewed-by: Simon Glass <sjg@chromium.org>
