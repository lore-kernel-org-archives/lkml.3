Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757286AbaDHQWU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 12:22:20 -0400
Received: from mail.skyhub.de ([78.46.96.112]:38398 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756849AbaDHQWS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 12:22:18 -0400
Date: Tue, 8 Apr 2014 18:22:13 +0200
From: Borislav Petkov <bp@alien8.de>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Thor Thayer <tthayer@altera.com>,
        "robherring2@gmail.com" <robherring2@gmail.com>,
        "dougthompson@xmission.com" <dougthompson@xmission.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "rob@landley.net" <rob@landley.net>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "dinguyen@altera.com" <dinguyen@altera.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] edac: altera: Add SDRAM EDAC support for
 CycloneV/ArriaV
Message-ID: <20140408162213.GL30077@pd.tnic>
References: <1396907649-20212-1-git-send-email-tthayer@altera.com>
 <1396907649-20212-4-git-send-email-tthayer@altera.com>
 <20140408100851.GF30077@pd.tnic>
 <1396965459.23349.4.camel@dinh-ubuntu>
 <20140408152406.GI30077@pd.tnic>
 <20140408154017.GF11876@e106331-lin.cambridge.arm.com>
 <20140408160351.GK30077@pd.tnic>
 <20140408161054.GA26210@e106331-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140408161054.GA26210@e106331-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 08, 2014 at 05:10:54PM +0100, Mark Rutland wrote:
> Typically the bindings would go with the driver via the appropriate
> subsystem maintainer. That way we don't get bindings without drivers
> or vice-versa if there's a problem part-way, and we don't end up with
> every other driver going via a dt tree.

Ok, I can pick them up then, once review is done.

@Thor, please CC linux-edac on the whole patchset for your next
submission.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
