Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753100Ab3DKTOo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 15:14:44 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:51136 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501Ab3DKTOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 15:14:42 -0400
MIME-Version: 1.0
In-Reply-To: <1365705391-23181-1-git-send-email-abrestic@chromium.org>
References: <1365705391-23181-1-git-send-email-abrestic@chromium.org>
Date: Thu, 11 Apr 2013 12:14:40 -0700
X-Google-Sender-Auth: MbmwEUp4NurTIoI_ePbHVom0YEM
Message-ID: <CAD=FV=X6BBWJMDzJR9tnjKj8xTZ3Ng9oS7PYtNdUenW7_86vqw@mail.gmail.com>
Subject: Re: [PATCH] backlight: platform_lcd: introduce probe callback
From: Doug Anderson <dianders@chromium.org>
To: Andrew Bresticker <abrestic@chromium.org>
Cc: linux-fbdev@vger.kernel.org, Richard Purdie <rpurdie@rpsys.net>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

On Thu, Apr 11, 2013 at 11:36 AM, Andrew Bresticker
<abrestic@chromium.org> wrote:
> +       if (pdata->probe) {
> +               err = pdata->probe(pdata);
> +               if (err) {
> +                       dev_err(dev, "platform probe failed: %d\n", err);

It would probably be good not to print in the case of -EPROBE_DEFER?

Otherwise this looks good to me.

-Doug
