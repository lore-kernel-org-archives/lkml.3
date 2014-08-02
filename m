Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753459AbaHBEss (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2014 00:48:48 -0400
Received: from mail-vc0-f170.google.com ([209.85.220.170]:45751 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752709AbaHBEsq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2014 00:48:46 -0400
MIME-Version: 1.0
In-Reply-To: <1406940750-15880-4-git-send-email-afaerber@suse.de>
References: <1406940750-15880-1-git-send-email-afaerber@suse.de>
	<1406940750-15880-4-git-send-email-afaerber@suse.de>
Date: Fri, 1 Aug 2014 21:48:44 -0700
X-Google-Sender-Auth: dVlKSrVwkRh5KWbl-OKfD4L9Y_8
Message-ID: <CAD=FV=W8U_bcXVqpdkVcrYL=X567dW+ayZc-vkfD_y_cCBngEQ@mail.gmail.com>
Subject: Re: [PATCH v6 03/10] ARM: dts: Prepare node labels for exynos5250
From: Doug Anderson <dianders@chromium.org>
To: =?UTF-8?Q?Andreas_F=C3=A4rber?= <afaerber@suse.de>
Cc: linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Stephan van Schaik <stephan@synkhronix.com>,
        Vincent Palatin <vpalatin@chromium.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Tomasz Figa <t.figa@samsung.com>, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas,

On Fri, Aug 1, 2014 at 5:52 PM, Andreas Färber <afaerber@suse.de> wrote:
> Allows them to be extended by reference.
>
> Signed-off-by: Andreas Färber <afaerber@suse.de>
> ---
>  v6: Split off from Snow/SMDK cleanups (Doug Anderson)
>
>  arch/arm/boot/dts/exynos5250.dtsi | 24 ++++++++++++------------
>  1 file changed, 12 insertions(+), 12 deletions(-)

Reviewed-by: Doug Anderson <dianders@chromium.org>
