Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081AbaKOLO1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2014 06:14:27 -0500
Received: from mout.kundenserver.de ([212.227.126.187]:58549 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752310AbaKOLOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2014 06:14:24 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Andrew Bresticker <abrestic@chromium.org>
Cc: Vinod Koul <vinod.koul@intel.com>, Dan Williams <dan.j.williams@intel.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        James Hartley <james.hartley@imgtec.com>,
        James Hogan <james.hogan@imgtec.com>,
        Ezequiel Garcia <ezequiel.garcia@imgtec.com>,
        Damien Horsley <Damien.Horsley@imgtec.com>, dmaengine@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 1/2] dmaengine: Add binding document for IMG MDC
Date: Sat, 15 Nov 2014 12:14:12 +0100
Message-ID: <7125302.mfyq7e6fDY@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1416002384-3525-2-git-send-email-abrestic@chromium.org>
References: <1416002384-3525-1-git-send-email-abrestic@chromium.org> <1416002384-3525-2-git-send-email-abrestic@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:r06PbO4qobf2UisQMElynxWqsT0EUprfa92/GhYw9of
 gWLt+klZu8tdiY+i7Bsbv/JbrPJ1cNrVsJYgoYy4zjeZ66fzbq
 LHWpsENpbnjVcx43WieXF70S5aahsMWipV/z8oXJlyzN1TPthh
 6kwW4nuIKcOwA9azUFMkkGBChPfapI2K3vwSriI8+X7asWRbsx
 zkhiorZnc86bz2mcP9ijQIupb/af5nscf7ruP1YdTLTlS0dGv6
 /ZksU+OMvlJxDS/KPteHoetSychgOLjai0OhJqbAMgd3694pvy
 JQaNKqHjUP0Iijr91CPD0tUtMUgqGFPI6D6PnLr3Amq56p7khV
 cdWwAxJk7jCpks1SrXPQ=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 14 November 2014 13:59:42 Andrew Bresticker wrote:
> Add a binding document for the IMG Multi-threaded DMA Controller (MDC)
> present on the MIPS-based Pistachio and other IMG SoCs.
> 
> Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
> 

Acked-by: Arnd Bergmann <arnd@arndb.de>
