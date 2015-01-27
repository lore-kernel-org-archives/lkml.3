Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757994AbbA0KAR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 05:00:17 -0500
Received: from mail-qc0-f176.google.com ([209.85.216.176]:50626 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754933AbbA0KAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 05:00:13 -0500
MIME-Version: 1.0
In-Reply-To: <1418338757-10022-1-git-send-email-abrestic@chromium.org>
References: <1418338757-10022-1-git-send-email-abrestic@chromium.org>
Date: Tue, 27 Jan 2015 10:00:12 +0000
X-Google-Sender-Auth: Mf_bPtmJ7hl87ERH90pM2juxCug
Message-ID: <CAL1qeaEF_J_VXvbF_VCPgacGGrbqagGALUm1m=T_yVqV7RooUg@mail.gmail.com>
Subject: Re: [PATCH V3 0/2] dmaengine: Support for IMG MDC
From: Andrew Bresticker <abrestic@chromium.org>
To: Vinod Koul <vinod.koul@intel.com>, Dan Williams <dan.j.williams@intel.com>
Cc: Andrew Bresticker <abrestic@chromium.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        James Hartley <james.hartley@imgtec.com>,
        James Hogan <james.hogan@imgtec.com>,
        Ezequiel Garcia <ezequiel.garcia@imgtec.com>,
        Damien Horsley <Damien.Horsley@imgtec.com>,
        Arnd Bergmann <arnd@arndb.de>, dmaengine@vger.kernel.org,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vinod,

On Thu, Dec 11, 2014 at 10:59 PM, Andrew Bresticker
<abrestic@chromium.org> wrote:
> This series adds support for the IMG Multi-threaded DMA Controller (MDC)
> which is found on IMG SoCs.  Currently this driver only supports the
> variant found on the MIPS-based Pistachio SoC.
>
> The MDC supports slave and memory-to-memory transfers on up to 32 channels.
> Requests from channels are handled by MDC threads.  Thread assignments are
> per-channel and are specified in the device-tree.
>
> Tested on a platform based on the Pistachio SoC with additional patches.
> Support for Pistachio will be submitted later.  Slave DMA was tested
> with the recently submitted IMG SPFI driver [1] and memory-to-memory
> DMA was tested with the dmatest module.
>
> Based on Vinod's slave-dma/topic/slave_caps_device_control_fix.

Any more comments on this series?  I'd like to get this in for 3.20 if possible.

Thanks!
Andrew
