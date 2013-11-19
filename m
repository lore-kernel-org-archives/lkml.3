Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753002Ab3KSWBN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 17:01:13 -0500
Received: from exprod5og101.obsmtp.com ([64.18.0.141]:42691 "HELO
	exprod5og101.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750812Ab3KSWBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 17:01:10 -0500
X-Greylist: delayed 1066 seconds by postgrey-1.27 at vger.kernel.org; Tue, 19 Nov 2013 17:01:10 EST
MIME-Version: 1.0
In-Reply-To: <1384294092-18794-1-git-send-email-fkan@apm.com>
References: <1384294092-18794-1-git-send-email-fkan@apm.com>
Date: Tue, 19 Nov 2013 14:01:09 -0800
Message-ID: <CAL85gmDaV-d5xS8gM1RFEqCsa3ocaym+bjxhFueYiqtf-N4NBg@mail.gmail.com>
Subject: Re: [PATCH 0/4] Add missing components for X-Gene reboot drivers.
From: Feng Kan <fkan@apm.com>
To: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        devicetree@vger.kernel.org
Cc: Feng Kan <fkan@apm.com>, Kumar Sankaran <ksankaran@apm.com>,
        Loc Ho <lho@apm.com>, jcm@redhat.com,
        Catalin Marinas <Catalin.Marinas@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Any comments on this?

On Tue, Nov 12, 2013 at 2:08 PM, Feng Kan <fkan@apm.com> wrote:
> Add dts node for X-Gene reboot driver. Apply documentation dts binding.
> Some minor compile warning fix and enable reboot driver by default.
>
> Feng Kan (4):
>   Documentation: add dts binding for X-Gene reboot dts node.
>   arm64: add missing dts entry for X-Gene platform.
>   arm64: Enable system reset via arch Kconfig for X-Gene system.
>   arm64: removed using of the mask attribute in the dts for reset bit.
>
>  .../devicetree/bindings/arm64/xgene/reboot.txt     |   11 +++++++++++
>  arch/arm64/Kconfig                                 |    1 +
>  arch/arm64/boot/dts/apm-storm.dtsi                 |    5 +++++
>  drivers/power/reset/xgene-reboot.c                 |    5 ++---
>  4 files changed, 19 insertions(+), 3 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/arm64/xgene/reboot.txt
>
> --
> 1.7.6.1
>
