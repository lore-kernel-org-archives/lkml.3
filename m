Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756575AbaDHPkh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 11:40:37 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:52277 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755932AbaDHPke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 11:40:34 -0400
Date: Tue, 8 Apr 2014 16:40:17 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Borislav Petkov <bp@alien8.de>
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
Message-ID: <20140408154017.GF11876@e106331-lin.cambridge.arm.com>
References: <1396907649-20212-1-git-send-email-tthayer@altera.com>
 <1396907649-20212-4-git-send-email-tthayer@altera.com>
 <20140408100851.GF30077@pd.tnic>
 <1396965459.23349.4.camel@dinh-ubuntu>
 <20140408152406.GI30077@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140408152406.GI30077@pd.tnic>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 08, 2014 at 04:24:06PM +0100, Borislav Petkov wrote:
> On Tue, Apr 08, 2014 at 08:57:39AM -0500, Thor Thayer wrote:
> > Yes, Altera has a group specifically supporting Linux drivers on the
> > Altera SoCs.
> 
> Then please add MAINTAINERS file entry for this EDAC driver so that
> people can send issues/reports to that group.
> 
> > I was told that the device tree additions should be separate patches
> > in a series since the device tree additions go to a separate group for
> > approval.
> 
> Well, the EDAC driver depends on the devicetree stuff, right? If so,
> they should go together.

The patches should be in the same series, but for review purposes it's
nicer if the bindings are separate patches from the code within that
series.

I usually look at the drivers implementing bindings and prefer to be
Cc'd on the whole series, with both the binding and driver.

Cheers,
Mark.
