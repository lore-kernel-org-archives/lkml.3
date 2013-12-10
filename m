Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755447Ab3LJRTB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 12:19:01 -0500
Received: from exprod5og113.obsmtp.com ([64.18.0.26]:38506 "HELO
	exprod5og113.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754597Ab3LJRS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 12:18:59 -0500
MIME-Version: 1.0
In-Reply-To: <1386181979-26547-1-git-send-email-fkan@apm.com>
References: <1386181979-26547-1-git-send-email-fkan@apm.com>
Date: Tue, 10 Dec 2013 09:18:58 -0800
Message-ID: <CAL85gmC1xRdwN0kj2w-ScNNFqEy8KC800gmV0NH36TCYcLg33Q@mail.gmail.com>
Subject: Re: [PATCH 0/4] Add missing components for X-Gene reboot drivers.
From: Feng Kan <fkan@apm.com>
To: patches <patches@apm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        devicetree@vger.kernel.org
Cc: Feng Kan <fkan@apm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Any update on this? Thanks

On Wed, Dec 4, 2013 at 10:32 AM, Feng Kan <fkan@apm.com> wrote:
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
