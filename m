Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751335AbaK1MPF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 07:15:05 -0500
Received: from kazi.fit.vutbr.cz ([147.229.8.12]:52367 "EHLO kazi.fit.vutbr.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750895AbaK1MPD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 07:15:03 -0500
Date: Fri, 28 Nov 2014 13:14:45 +0100
From: Tomas Novotny <tomas@novotny.cz>
To: akpm@linux-foundation.org
Cc: rtc-linux@googlegroups.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alessandro Zummo <a.zummo@towertech.it>,
        grant.likely@linaro.org, robh+dt@kernel.org
Subject: Re: [PATCH 0/4] rtc: ds1307: add support for device tree and
 mcp7940x
Message-ID: <20141128131445.181a6e27@tomas.local.tbs-biometrics.cz>
In-Reply-To: <20141127161741.52e8d300@tomas>
References: <1416844164-16782-1-git-send-email-tomas@novotny.cz>
	<20141127161741.52e8d300@tomas>
X-Mailer: Claws Mail 3.11.0 (GTK+ 2.24.25; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On Thu, 27 Nov 2014 16:17:41 +0100, Tomas Novotny <tomas@novotny.cz> wrote:
> On Mon, 24 Nov 2014 16:49:20 +0100
> Tomas Novotny <tomas@novotny.cz> wrote:
> 
> > This series is tested with MCP79401 and it is based on 3.18-rc6.
> > 
> > Tomas Novotny (4):
> >   rtc: ds1307: add support for mcp7940x chips
> >   of: add vendor prefix for Pericom Technology
> >   rtc: ds1307: add device tree bindings documentation
> >   rtc: ds1307: add device tree support
> >
> >  .../devicetree/bindings/rtc/maxim,ds1307.txt       |  23 ++++
> >  .../devicetree/bindings/vendor-prefixes.txt        |   1 +
> >  drivers/rtc/rtc-ds1307.c                           | 149 ++++++++++++---------
> >  3 files changed, 110 insertions(+), 63 deletions(-)
> >  create mode 100644 Documentation/devicetree/bindings/rtc/maxim,ds1307.txt
> 
> It is now in the -mm and linux-next.
> Thanks to Andrew for pick up,
> 
> Tomas

could you please remove my last two patches:
rtc-ds1307-add-device-tree-bindings-documentation.patch
rtc-ds1307-add-device-tree-support.patch
from the -mm?
	I missed that some compatible RTC's are already listed in
i2c/trivial-devices.txt. These two patches shouldn't break anything, but
document and handle already working thing.
	Better would be to follow the trivial-devices.txt and add the missing
compatibles there.
	The first two patches are ok.
	Sorry for the noise and thanks,

	Tomas
