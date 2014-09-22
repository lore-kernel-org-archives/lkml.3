Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754481AbaIVQvq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 12:51:46 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:59690 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754033AbaIVQvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 12:51:43 -0400
MIME-Version: 1.0
In-Reply-To: <1411329923-15912-2-git-send-email-heiko@sntech.de>
References: <1411329923-15912-1-git-send-email-heiko@sntech.de>
	<1411329923-15912-2-git-send-email-heiko@sntech.de>
Date: Mon, 22 Sep 2014 09:51:43 -0700
X-Google-Sender-Auth: dhxvgOpzpeQB0gvJ1ECy1jW9ILk
Message-ID: <CAD=FV=V1wQfXvyx5XP-KwdES=MKzBBFi2977+U=SzCMvxaS8Kg@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] dt-bindings: document gpio-charger bindings
From: Doug Anderson <dianders@chromium.org>
To: Heiko Stuebner <heiko@sntech.de>
Cc: sre@kernel.org, Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Heiko Stuebner <heiko.stuebner@bq.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Heiko,

On Sun, Sep 21, 2014 at 1:05 PM, Heiko Stuebner <heiko@sntech.de> wrote:
> From: Heiko Stuebner <heiko.stuebner@bq.com>
>
> This documents the binding for the gpio-charger power-supply.
>
> Signed-off-by: Heiko Stuebner <heiko.stuebner@bq.com>
> ---
>  .../bindings/power_supply/gpio-charger.txt         | 27 ++++++++++++++++++++++
>  1 file changed, 27 insertions(+)

It is not an area I'm an expert on, but this seems pretty reasonable to me.

Reviewed-by: Doug Anderson <dianders@chromium.org>
