Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933523AbaFRD3U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 23:29:20 -0400
Received: from mail-qa0-f41.google.com ([209.85.216.41]:63151 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756572AbaFRD3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 23:29:19 -0400
MIME-Version: 1.0
In-Reply-To: <1402954800-28215-3-git-send-email-dianders@chromium.org>
References: <1402954800-28215-1-git-send-email-dianders@chromium.org>
	<1402954800-28215-3-git-send-email-dianders@chromium.org>
Date: Tue, 17 Jun 2014 20:29:17 -0700
X-Google-Sender-Auth: vt-fKf0h1fBU0gjueFIwHo1RhOs
Message-ID: <CAPnjgZ3QjefCXHB38hwMf_+iduZq4MPQV9nbZ=WjAFe1RnSdtQ@mail.gmail.com>
Subject: Re: [PATCH 02/10] mfd: cros_ec: IRQs for cros_ec should be optional
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

On 16 June 2014 14:39, Doug Anderson <dianders@chromium.org> wrote:
> From: Bill Richardson <wfrichar@chromium.org>
>
> Preparing the way for the LPC device, which is just a plaform_device without
> interrupts.
>
> Signed-off-by: Bill Richardson <wfrichar@chromium.org>
> Signed-off-by: Doug Anderson <dianders@chromium.org>

Reviewed-by: Simon Glass <sjg@chromium.org>
