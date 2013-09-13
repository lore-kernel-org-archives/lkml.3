Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755913Ab3IMX4G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 19:56:06 -0400
Received: from mail-qc0-f171.google.com ([209.85.216.171]:63625 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755563Ab3IMX4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 19:56:01 -0400
MIME-Version: 1.0
In-Reply-To: <1379109160-32437-1-git-send-email-bleung@chromium.org>
References: <1379109160-32437-1-git-send-email-bleung@chromium.org>
Date: Fri, 13 Sep 2013 16:56:00 -0700
X-Google-Sender-Auth: 8JFtFxTqu7OD-jUjj-6HdDk43iY
Message-ID: <CAD=FV=VeVYNAQMrGHdQFubeQOFqA0TQirDTMagYLw5u5pTkbMg@mail.gmail.com>
Subject: Re: [PATCH] Input: gpio_keys - wakeup_trigger
From: Doug Anderson <dianders@chromium.org>
To: Benson Leung <bleung@chromium.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-input@vger.kernel.org, linux-gpio@vger.kernel.org,
        devicetree@vger.kernel.org, david@protonic.nl
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benson,

On Fri, Sep 13, 2013 at 2:52 PM, Benson Leung <bleung@chromium.org> wrote:
> Allow wakeup_trigger to be defined per gpio button. Currently, all
> gpio buttons are set up as IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING.
> It may be more appropriate to only wake the system on one edge, for example
> if the gpio is for a Lid Switch.
>
> Signed-off-by: Benson Leung <bleung@chromium.org>

As discussed out of band, I'd tend to put the masking/error checking
in gpio_keys_get_devtree_pdata() then just rely on non-DT users not to
pass in nonsense, but I don't feel that strongly about it, so:

Reviewed-by: Doug Anderson <dianders@chromium.org>
