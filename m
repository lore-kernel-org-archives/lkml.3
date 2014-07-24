Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932624AbaGXMqK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 08:46:10 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:34840 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932137AbaGXMqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 08:46:06 -0400
MIME-Version: 1.0
In-Reply-To: <1406154923-13612-1-git-send-email-yahoo@perenite.com>
References: <1406154923-13612-1-git-send-email-yahoo@perenite.com>
From: Rob Herring <robherring2@gmail.com>
Date: Thu, 24 Jul 2014 07:45:45 -0500
Message-ID: <CAL_JsqJxZ75zCn4++949FQvEtXjk0K6kNj58O+UqVcqU20Pduw@mail.gmail.com>
Subject: Re: [PATCH 1/2] Adding Lenovo - Lenovo Group Ltd. to the
 vendor-prefixes list.
To: Benoit Masson <yahoo@perenite.com>
Cc: benoitm@perenite.com, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        sebastian.hesselbarth@googlemail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 5:35 PM, Benoit Masson <yahoo@perenite.com> wrote:
> Lenovo Group Ltd. (stylized as lenovo) is a Chinese multinational computer technology company with headquarters in Beijing, China, and Morrisville, North Carolina, United States.
>
> http://www.lenovo.com/
> Signed-off-by: Benoit Masson <yahoo@perenite.com>

Acked-by: Rob Herring <robh@kernel.org>

> ---
>  Documentation/devicetree/bindings/vendor-prefixes.txt | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
> index 46a311e..ae09892 100644
> --- a/Documentation/devicetree/bindings/vendor-prefixes.txt
> +++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
> @@ -71,6 +71,7 @@ karo  Ka-Ro electronics GmbH
>  keymile        Keymile GmbH
>  lacie  LaCie
>  lantiq Lantiq Semiconductor
> +lenovo Lenovo Group Ltd.
>  lg     LG Corporation
>  linux  Linux-specific binding
>  lsi    LSI Corp. (LSI Logic)
> --
> 1.9.1
>
