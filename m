Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753990AbaKOLOL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2014 06:14:11 -0500
Received: from mout.kundenserver.de ([212.227.17.13]:59273 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752649AbaKOLOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2014 06:14:09 -0500
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
Subject: Re: [PATCH V2 2/2] dmaengine: Add driver for IMG MDC
Date: Sat, 15 Nov 2014 12:13:47 +0100
Message-ID: <12652776.7LHRgbiJ2i@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1416002384-3525-3-git-send-email-abrestic@chromium.org>
References: <1416002384-3525-1-git-send-email-abrestic@chromium.org> <1416002384-3525-3-git-send-email-abrestic@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:/aMTCLdY4UrRDwbW6xirWeGhv4FcTF8rWAe0OWXD7kk
 WqyVdIdr11viebIiK2SAJNV0QuW7LwbayYeMSj07FfollDk3Za
 M0qFY3e7eprYwJgk25eiL1PvLesfVAaZFcAtl2u2W9Vz+S10JT
 MWoVaORipFjz7XWBmpBW1+rLYSBXBi72bKw/RskoRRVXVfboQY
 JSfhmbpXzhe1F4A5ZaUo1o+ehN5EVlhtJix0SHO8EzpgSQAjri
 VBJdJXTxGHv2fF2bxaG8umrMym/RhAz/zy44Bu6IRhtE7teWkH
 vZ+sulS5c8CuokgMgNm+O2tB6iB97E7agWLzlnGoF1ql/pDajD
 XC/ooHOWg1BHV8VkN/rU=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 14 November 2014 13:59:43 Andrew Bresticker wrote:
> Add support for the IMG Multi-threaded DMA Controller (MDC) found on
> certain IMG SoCs.  Currently this driver supports the variant present
> on the MIPS-based Pistachio SoC.
> 
> Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
> 

Acked-by: Arnd Bergmann <arnd@arndb.de>
