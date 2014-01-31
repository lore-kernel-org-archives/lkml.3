Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932640AbaAaR3Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 12:29:25 -0500
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:18491 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932236AbaAaR3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 12:29:23 -0500
Date: Fri, 31 Jan 2014 09:31:03 -0800
From: Courtney Cavin <courtney.cavin@sonymobile.com>
To: Georgi Djakov <gdjakov@mm-sol.com>
CC: "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "cjb@laptop.org" <cjb@laptop.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "rob@landley.net" <rob@landley.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "subhashj@codeaurora.org" <subhashj@codeaurora.org>
Subject: Re: [PATCH v7 2/2] mmc: sdhci-msm: Initial support for MSM chipsets
Message-ID: <20140131173102.GE19653@sonymobile.com>
References: <1383753405-23631-1-git-send-email-gdjakov@mm-sol.com>
 <1383753405-23631-3-git-send-email-gdjakov@mm-sol.com>
 <20131209170002.GA15223@sonymobile.com>
 <52EA8A07.6080008@mm-sol.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <52EA8A07.6080008@mm-sol.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 30, 2014 at 06:21:11PM +0100, Georgi Djakov wrote:
> Hi,
> 
> Apologies for the delayed reply.
> 
> On 12/09/2013 07:00 PM, Courtney Cavin wrote:
> > On Wed, Nov 06, 2013 at 04:56:45PM +0100, Georgi Djakov wrote:
> >> This platform driver adds the initial support of Secure
> >> Digital Host Controller Interface compliant controller
> >> found in Qualcomm MSM chipsets.
> >>
> >> Signed-off-by: Georgi Djakov <gdjakov@mm-sol.com>
[...]
> >
> > I couldn't get v6 running without the 5 quirks you submitted in [1].
> > Aren't these also attributes of the controller itself? If so, shouldn't they
> > be part of this patch series, and included here?
> >
> 
> Most of the quirks are for older hardware revisions. On what board/chip 
> are you trying to run it? I will post v8 shortly. Could you try with it 
> please?

I see.  This was initially checked on a Rev 1 SoC.  I will test v8 on a
Rev 2.

-Courtney
