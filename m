Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751310AbaGaNRI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 09:17:08 -0400
Received: from mail.skyhub.de ([78.46.96.112]:60526 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750866AbaGaNRG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 09:17:06 -0400
Date: Thu, 31 Jul 2014 15:17:02 +0200
From: Borislav Petkov <bp@alien8.de>
To: Michal Simek <michal.simek@xilinx.com>
Cc: Punnaiah Choudary Kalluri <punnaiah.choudary.kalluri@xilinx.com>,
        "dougthompson@xmission.com" <dougthompson@xmission.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Punnaiah Choudary <kpc528@gmail.com>,
        Anirudha Sarangi <anirudh@xilinx.com>,
        Srikanth Vemula <svemula@xilinx.com>
Subject: Re: [RFC PATCH v3] edac: synps: Added EDAC support for zynq ddr ecc
 controller
Message-ID: <20140731131702.GC4375@pd.tnic>
References: <9dc2a947-d2ab-4f00-8ed3-d2499cb6fdfd@BN1BFFO11FD002.protection.gbl>
 <20140731113324.GB4375@pd.tnic>
 <808655a9-77eb-4e3a-9781-2b059ad9517b@BN1AFFO11FD020.protection.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <808655a9-77eb-4e3a-9781-2b059ad9517b@BN1AFFO11FD020.protection.gbl>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 31, 2014 at 02:13:48PM +0200, Michal Simek wrote:
> Mixing two drivers in the one file is not a good idea because with
> more memory controllers it is just a mess and you are not able to
> cover all cases.

Why is it a mess?

> If this is just about providing uniq number we can easily extend
> binding and provide that uniq value. That's remind me solution with
> edac_mc_get_id() can caused that you won't have exact number all the
> time - depends on driver loading (deferred probing too).

-ENOPARSE for this sentence.

> One option via DT can be via aliases where you can easily specify
> order. But all of these issues can be solved in follow-up patch.

Whatever you do, it should be designed cleanly and not introduce some
homegrown solution.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
