Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933893AbaFRDjG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 23:39:06 -0400
Received: from mail-qg0-f54.google.com ([209.85.192.54]:56420 "EHLO
	mail-qg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933617AbaFRDjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 23:39:04 -0400
MIME-Version: 1.0
In-Reply-To: <1402954800-28215-8-git-send-email-dianders@chromium.org>
References: <1402954800-28215-1-git-send-email-dianders@chromium.org>
	<1402954800-28215-8-git-send-email-dianders@chromium.org>
Date: Tue, 17 Jun 2014 20:39:02 -0700
X-Google-Sender-Auth: iPd-Y0IT3Nin0i9B4-gW5i2_g10
Message-ID: <CAPnjgZ0Qj=5=5xtBoK7b+1Qn+VbBeeSPr+K5uiSMv3fU2ejXfQ@mail.gmail.com>
Subject: Re: [PATCH 07/10] mfd: cros_ec: cleanup: remove unused fields from
 struct cros_ec_device
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

Hi Doug,

On 16 June 2014 14:39, Doug Anderson <dianders@chromium.org> wrote:
> From: Bill Richardson <wfrichar@chromium.org>
>
> struct cros_ec_device has a superfluous "name" field. We can get all the
> debugging info we need from the existing ec_name and phys_name fields, so
> let's take out the extra field.

Except that it no longer prints I2C/SPI - i.e. the transport that is
used. Is that not considered important?

Anyway:

Reviewed-by: Simon Glass <sjg@chromium.org>

Regards,
Simon
