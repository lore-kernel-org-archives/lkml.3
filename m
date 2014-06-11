Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755279AbaFKMJP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 08:09:15 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:55666 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750730AbaFKMJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 08:09:13 -0400
MIME-Version: 1.0
In-Reply-To: <bf4b6d7b061e66d3ca7f3dd44319b9e26ae7103f.1402484954.git.Adam.Thomson.Opensource@diasemi.com>
References: <cover.1402484954.git.Adam.Thomson.Opensource@diasemi.com>
	<bf4b6d7b061e66d3ca7f3dd44319b9e26ae7103f.1402484954.git.Adam.Thomson.Opensource@diasemi.com>
Date: Wed, 11 Jun 2014 14:09:11 +0200
X-Google-Sender-Auth: 59E3op8ec7dyass3m_aF1KP8Apw
Message-ID: <CAMuHMdWirVk+jrz40yw4=zAOFH6VTX9CXcpO01e0rK8S8VGGHw@mail.gmail.com>
Subject: Re: [PATCH 8/8] DT: Add vendor prefix for Dialog Semiconductor Ltd.
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
Cc: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Jonathan Cameron <jic23@kernel.org>, linux-iio@vger.kernel.org,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        support.opensource@diasemi.com,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2014 at 1:11 PM, Adam Thomson
<Adam.Thomson.Opensource@diasemi.com> wrote:
> --- a/Documentation/devicetree/bindings/vendor-prefixes.txt
> +++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
> @@ -36,6 +36,7 @@ dallas        Maxim Integrated Products (formerly Dallas Semiconductor)
>  davicom        DAVICOM Semiconductor, Inc.
>  denx   Denx Software Engineering
>  digi   Digi International Inc.
> +dlg    Dialog Semiconductor Ltd.

"diasemi" has been proposed before
https://groups.google.com/forum/#!msg/linux.kernel/htUxLpV_Ng0/ClJVAxgK4e4J

"dialog", "diasemi", and "dlg" all seem to be already in use...

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
