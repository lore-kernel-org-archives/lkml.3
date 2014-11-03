Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752626AbaKCOlJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 09:41:09 -0500
Received: from mail-la0-f43.google.com ([209.85.215.43]:46248 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972AbaKCOlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 09:41:05 -0500
MIME-Version: 1.0
In-Reply-To: <A765B125120D1346A63912DDE6D8B6315E982C@NTXXIAMBX02.xacn.micron.com>
References: <A765B125120D1346A63912DDE6D8B6315E9827@NTXXIAMBX02.xacn.micron.com>
 <A765B125120D1346A63912DDE6D8B6315E982C@NTXXIAMBX02.xacn.micron.com>
From: Rob Herring <robherring2@gmail.com>
Date: Mon, 3 Nov 2014 08:40:41 -0600
Message-ID: <CAL_JsqLxs5Mj2FvTkbuEcgm19Xc-Me7BkcLsPQ6J+x8EqTr2LA@mail.gmail.com>
Subject: Re: [PATCH 1/1] devicetree: bindings: Add vendor prefix for Micron
 Technology Co., Ltd.
To: bpqw <bpqw@micron.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Jason Cooper <jason@lakedaemon.net>,
        Mark Brown <broonie@kernel.org>, Heiko Stuebner <heiko@sntech.de>,
        Thierry Reding <treding@nvidia.com>,
        Florian Vaussard <florian.vaussard@epfl.ch>,
        Andrew Lunn <andrew@lunn.ch>, Silvio F <silvio.fricke@gmail.com>,
        Hayato Suzuki <hytszk@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 3, 2014 at 8:28 AM, bpqw <bpqw@micron.com> wrote:
>>This patch is used to add vendor prefix for
>>Micron Technology Inc in the vendor-prefixes.txt file.
>
>>Micron Technology, Inc. is an American
>>multinational corporation based in Boise,
>>Idaho, best known for producing many forms
>>of semiconductor devices. This includes DRAM,
>>SDRAM, flash memory, eMMC and SSDs.
>
>>Signed-off-by: bean huo <beanhuo@micron.com>
>
> Dear linux developer:
>
> Is there maintainer in this mail list? Can give me a result for
> this simple patch?if can be accepted or not? Or give me some suggections?
> It has been long time.

It has been 6 minutes since you sent the last version.

I see you have fixed the line length although I'm not sure why you
made it so short. 72 characters is the norm, but up to 80 is fine. You
have not fixed the authorship as Mark pointed out.

Also, please version your patches (i.e. [PATCH v2]).

Rob
