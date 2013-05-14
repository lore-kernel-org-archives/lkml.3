Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755378Ab3ENQuo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 12:50:44 -0400
Received: from mail-qa0-f43.google.com ([209.85.216.43]:49783 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321Ab3ENQun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 12:50:43 -0400
Date: Tue, 14 May 2013 12:50:40 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Chris Ball <cjb@laptop.org>
cc: linux-kernel@vger.kernel.org, Doug Anderson <dianders@chromium.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Johan Rudholm <johan.rudholm@stericsson.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Konstantin Dorfman <kdorfman@codeaurora.org>,
        linux-mmc@vger.kernel.org
Subject: Re: [PATCH] mmc: core: Add a capability for disabling mmc cards
In-Reply-To: <874ne5n6zv.fsf@octavius.laptop.org>
Message-ID: <alpine.LFD.2.03.1305141246180.31158@syhkavp.arg>
References: <1368517100-22243-1-git-send-email-adam.lee@canonical.com> <20130514075333.GA22435@adam-laptop> <874ne5n6zv.fsf@octavius.laptop.org>
User-Agent: Alpine 2.03 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 May 2013, Chris Ball wrote:

> Hi,
> 
> On Tue, May 14 2013, Adam Lee wrote:
> > On Tue, May 14, 2013 at 03:38:17PM +0800, Adam Lee wrote:
> >> On some systems we need a way to disable MMC card support in a MMC/SD
> >> card slot due to the legal concern.
> >> 
> >> Add support in the core SD/MMC code to support this.
> >
> > CC more addresses.
> >
> > Yes, this capability seems odd, but linux computer vendors need this to
> > avoid legal problems. Please review, thanks.
> 
> This has already been NACKed by Nicolas:
> 
> https://patchwork.kernel.org/patch/1359121/
> 
> (At least, I think it has -- your forward doesn't include the patch
> itself.)

I certainly did.  Technical amputations driven by legal stupidities 
don't belong in the mainline kernel.


Nicolas
