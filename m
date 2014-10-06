Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753104AbaJFPHf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 11:07:35 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:37826 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753073AbaJFPHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 11:07:30 -0400
MIME-Version: 1.0
In-Reply-To: <1412546359-15062-5-git-send-email-b.galvani@gmail.com>
References: <1412546359-15062-1-git-send-email-b.galvani@gmail.com> <1412546359-15062-5-git-send-email-b.galvani@gmail.com>
From: Rob Herring <robherring2@gmail.com>
Date: Mon, 6 Oct 2014 10:07:08 -0500
Message-ID: <CAL_JsqJS82SzUsZKDom-cNcnWDurtEaJQRDnPnMQiO8u57=Gwg@mail.gmail.com>
Subject: Re: [PATCH v2 4/7] of: add vendor prefix for Tronsmart
To: Beniamino Galvani <b.galvani@gmail.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Arnd Bergmann <arnd@arndb.de>, Carlo Caione <carlo@caione.org>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Jerry Cao <jerry.cao@amlogic.com>,
        Victor Wan <victor.wan@amlogic.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 5, 2014 at 4:59 PM, Beniamino Galvani <b.galvani@gmail.com> wrote:
> This adds Tronsmart to the list of device tree vendor prefixes.
>
> Signed-off-by: Beniamino Galvani <b.galvani@gmail.com>

Acked-by: Rob Herring <robh@kernel.org>

> ---
>  Documentation/devicetree/bindings/vendor-prefixes.txt | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
> index c681434..92a1798 100644
> --- a/Documentation/devicetree/bindings/vendor-prefixes.txt
> +++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
> @@ -141,6 +141,7 @@ tlm Trusted Logic Mobility
>  toradex        Toradex AG
>  toshiba        Toshiba Corporation
>  toumaz Toumaz
> +tronsmart      Tronsmart
>  usi    Universal Scientifc Industrial Co., Ltd.
>  v3     V3 Semiconductor
>  variscite      Variscite Ltd.
> --
> 1.9.1
>
