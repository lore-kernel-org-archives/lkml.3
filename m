Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753936AbbAEPMN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 10:12:13 -0500
Received: from mail-qa0-f51.google.com ([209.85.216.51]:64039 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753403AbbAEPML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 10:12:11 -0500
MIME-Version: 1.0
In-Reply-To: <20150105101546.GA19655@pd.tnic>
References: <d71411fd1be84d99af5936138cbcc9c7@BL2FFO11FD014.protection.gbl>
	<20150102105008.GA31364@pd.tnic>
	<CAGnW=BbrpMoMGSVmFXUAYsnyOPGpkz=HbL6mRzB7PqRhbq5HTA@mail.gmail.com>
	<20150105101546.GA19655@pd.tnic>
Date: Mon, 5 Jan 2015 20:42:10 +0530
X-Google-Sender-Auth: 175Ed5st1x9QVCf_OWVhNITDeD4
Message-ID: <CAGnW=BZ9L9uGDNGsz016Vc+mFf_NtVmrmm56HWg1PTYxgxDmVQ@mail.gmail.com>
Subject: Re: [PATCH v7] edac: synps: Added EDAC support for zynq ddr ecc controller
From: punnaiah choudary kalluri <punnaia@xilinx.com>
To: Borislav Petkov <bp@alien8.de>
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
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 5, 2015 at 3:45 PM, Borislav Petkov <bp@alien8.de> wrote:
> On Sat, Jan 03, 2015 at 08:01:29AM +0530, punnaiah choudary kalluri wrote:
>> p is pointing to the stack memory.
>
> So you could go and allocate all that memory at driver init time and
> reuse it each time you handle an error instead of on the stack. This way
> your error handling paths are lean and fast.

Ok. I will update it.

Thanks,
Punnaiah
>
> --
> Regards/Gruss,
>     Boris.
>
> Sent from a fat crate under my desk. Formatting is fine.
> --
> --
> To unsubscribe from this list: send the line "unsubscribe linux-edac" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
