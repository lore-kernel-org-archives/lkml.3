Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753716AbbAEKPw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 05:15:52 -0500
Received: from mail.skyhub.de ([78.46.96.112]:33580 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753326AbbAEKPu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 05:15:50 -0500
Date: Mon, 5 Jan 2015 11:15:46 +0100
From: Borislav Petkov <bp@alien8.de>
To: punnaiah choudary kalluri <punnaia@xilinx.com>
Cc: Punnaiah Choudary Kalluri <punnaiah.choudary.kalluri@xilinx.com>,
        dougthompson@xmission.com,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-edac@vger.kernel.org,
        "michal.simek@xilinx.com" <michal.simek@xilinx.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Punnaiah Choudary <kpc528@gmail.com>
Subject: Re: [PATCH v7] edac: synps: Added EDAC support for zynq ddr ecc
 controller
Message-ID: <20150105101546.GA19655@pd.tnic>
References: <d71411fd1be84d99af5936138cbcc9c7@BL2FFO11FD014.protection.gbl>
 <20150102105008.GA31364@pd.tnic>
 <CAGnW=BbrpMoMGSVmFXUAYsnyOPGpkz=HbL6mRzB7PqRhbq5HTA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAGnW=BbrpMoMGSVmFXUAYsnyOPGpkz=HbL6mRzB7PqRhbq5HTA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 03, 2015 at 08:01:29AM +0530, punnaiah choudary kalluri wrote:
> p is pointing to the stack memory.

So you could go and allocate all that memory at driver init time and
reuse it each time you handle an error instead of on the stack. This way
your error handling paths are lean and fast.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
