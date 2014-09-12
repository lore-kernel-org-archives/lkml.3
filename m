Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752700AbaILQD4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 12:03:56 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:52308 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951AbaILQDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 12:03:52 -0400
MIME-Version: 1.0
In-Reply-To: <5413173A.9070705@collabora.co.uk>
References: <1410509864-10019-1-git-send-email-javier.martinez@collabora.co.uk>
	<1410509864-10019-2-git-send-email-javier.martinez@collabora.co.uk>
	<CAD=FV=Vu3u=KfUNUpL6qcr0Fp42WbY8AqfOXyWr-D3KW1PucxA@mail.gmail.com>
	<5413173A.9070705@collabora.co.uk>
Date: Fri, 12 Sep 2014 09:03:50 -0700
X-Google-Sender-Auth: i5UQMhGR77weEWgvxJIZZO4GOBI
Message-ID: <CAD=FV=W3soOh2yf0pDcP0cXVGvxcbyTkO7z-1k0rV7DJAyhf=g@mail.gmail.com>
Subject: Re: [PATCH RESEND v9 1/5] rtc: max77686: Allow the max77686 rtc to
 wakeup the system
From: Doug Anderson <dianders@chromium.org>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Olof Johansson <olof@lixom.net>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        rtc-linux@googlegroups.com,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Sep 12, 2014 at 8:54 AM, Javier Martinez Canillas
<javier.martinez@collabora.co.uk> wrote:
> You are right, I completely forgot to check if that actually landed and to
> remove the note in that case...
>
> Maybe when the set is applied the note can be removed from this patch or do
> you think that I should re-spin the series for that?

This seems like something a maintainer could handle removing, but I
guess it's totally up to the maintainer.  If I were the maintainer I'd
rather remove the note myself then see a whole spin of a 5-part series
just to fix this.  ;)


-Doug
