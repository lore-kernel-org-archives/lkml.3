Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932330AbaIEMqm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 08:46:42 -0400
Received: from mail-vc0-f170.google.com ([209.85.220.170]:65213 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932155AbaIEMqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 08:46:40 -0400
MIME-Version: 1.0
In-Reply-To: <1409899692-1455-6-git-send-email-rric@kernel.org>
References: <1409899692-1455-1-git-send-email-rric@kernel.org> <1409899692-1455-6-git-send-email-rric@kernel.org>
From: Rob Herring <robherring2@gmail.com>
Date: Fri, 5 Sep 2014 07:46:19 -0500
Message-ID: <CAL_JsqLJ+zuqx9RELw3p2Pa13QuXsDR3Fv1Qcaeqk+R6HXy9uQ@mail.gmail.com>
Subject: Re: [PATCH 5/6] dts, arm64: Move dts files to vendor subdirs
To: Robert Richter <rric@kernel.org>
Cc: Olof Johansson <olof@lixom.net>, Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Michal Marek <mmarek@suse.cz>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-kbuild@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Robert Richter <rrichter@cavium.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 5, 2014 at 1:48 AM, Robert Richter <rric@kernel.org> wrote:
> From: Robert Richter <rrichter@cavium.com>
>
> Moving dts files to vendor subdirs.
>
> Signed-off-by: Robert Richter <rrichter@cavium.com>
> ---
>  arch/arm64/boot/dts/Makefile                     |   4 +-
>  arch/arm64/boot/dts/apm-mustang.dts              |  34 --
>  arch/arm64/boot/dts/apm-storm.dtsi               | 425 -----------------------
>  arch/arm64/boot/dts/apm/Makefile                 |   5 +
>  arch/arm64/boot/dts/apm/apm-mustang.dts          |  34 ++
>  arch/arm64/boot/dts/apm/apm-storm.dtsi           | 425 +++++++++++++++++++++++
>  arch/arm64/boot/dts/arm/Makefile                 |   6 +
>  arch/arm64/boot/dts/arm/foundation-v8.dts        | 232 +++++++++++++
>  arch/arm64/boot/dts/arm/rtsm_ve-aemv8a.dts       | 159 +++++++++
>  arch/arm64/boot/dts/arm/rtsm_ve-motherboard.dtsi | 240 +++++++++++++
>  arch/arm64/boot/dts/foundation-v8.dts            | 232 -------------
>  arch/arm64/boot/dts/rtsm_ve-aemv8a.dts           | 159 ---------
>  arch/arm64/boot/dts/rtsm_ve-motherboard.dtsi     | 240 -------------
>  13 files changed, 1103 insertions(+), 1092 deletions(-)

This should be sent with renames enabled (-M option). You can enable
it by default with this in your git config:

[diff]
        renames = true

Otherwise,

Acked-by: Rob Herring <robh@kernel.org>

Rob
