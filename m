Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933243Ab3LDTY6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 14:24:58 -0500
Received: from mail-vc0-f177.google.com ([209.85.220.177]:33036 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933010Ab3LDTY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 14:24:56 -0500
MIME-Version: 1.0
In-Reply-To: <cover.1385623064.git.peter.crosthwaite@xilinx.com>
References: <cover.1385623064.git.peter.crosthwaite@xilinx.com>
Date: Wed, 4 Dec 2013 13:24:55 -0600
Message-ID: <CAL_JsqJsQdKATAQqtPtMBENOBxb3=Dy0DvXFmT3uGh1+QfPH6w@mail.gmail.com>
Subject: Re: [PATCH v1 0/2] of: irq: Ignore disabled interrupt controllers
From: Rob Herring <robherring2@gmail.com>
To: Peter Crosthwaite <peter.crosthwaite@xilinx.com>
Cc: grant-likely@linaro.org,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 28, 2013 at 1:26 AM, Peter Crosthwaite
<peter.crosthwaite@xilinx.com> wrote:
> Hi All,
>
> These two patches support the case where an interrupt controller is
> marked as disabled. Patch 1 fixed the dts interrupt-map search logic to
> ignore disabled interrupt controllers. Patch 2 stops disabled interrupt
> controllers getting probed.
>
> Peter Crosthwaite (2):
>   of: irq: Ignore disabled intc's when searching map
>   of: irq: Ignore disabled interrupt controllers
>
>  drivers/of/irq.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)

Applied both patches. Thanks.

Rob
