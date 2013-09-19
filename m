Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752900Ab3ISUn4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 16:43:56 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:48033 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752519Ab3ISUno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 16:43:44 -0400
MIME-Version: 1.0
In-Reply-To: <106090496.3hTZTLSVzK@flatron>
References: <1379109160-32437-1-git-send-email-bleung@chromium.org>
	<106090496.3hTZTLSVzK@flatron>
Date: Thu, 19 Sep 2013 13:43:43 -0700
X-Google-Sender-Auth: S0reHsNFfkOeKtvJpuh1lFonuGg
Message-ID: <CANLzEkufu+MA67tBi9eXDTzPrSqT9jUNpMiCqeqckJog1JdVbA@mail.gmail.com>
Subject: Re: [PATCH] Input: gpio_keys - wakeup_trigger
From: Benson Leung <bleung@chromium.org>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-input@vger.kernel.org, linux-gpio@vger.kernel.org,
        devicetree@vger.kernel.org, david@protonic.nl,
        Douglas Anderson <dianders@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomasz,

On Sat, Sep 14, 2013 at 5:16 AM, Tomasz Figa <tomasz.figa@gmail.com> wrote:
> I don't like two things in this patch.
>
> First is that this looks completely like a configuration option, not
> hardware description, so it's not something that should be put into DT.
> Especially that users might want to use another wake-up trigger depending
> on their use cases. I'd rather see this as a sysfs entry.
>
> Another thing is that this driver assumes that key events are indicated by
> edges on the GPIO line, so I don't think level trigger setting make any
> sense here. I'd rather allow three settings here (through a sysfs knob) -
> key down, key up, key down or up.

Thanks for your feedback. I agree with your suggestions. I will move
this from platform data and DT to a sysfs property with three settings
: rising, falling, both.


-- 
Benson Leung
Software Engineer, Chrom* OS
bleung@chromium.org
