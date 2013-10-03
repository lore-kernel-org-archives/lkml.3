Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727Ab3JCPfi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 11:35:38 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:16350 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754253Ab3JCPff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 11:35:35 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 03 Oct 2013 08:31:30 -0700
Date: Thu, 3 Oct 2013 18:35:19 +0300
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>,
        Mike Turquette <mturquette@linaro.org>
CC: Prashant Gaikwad <pgaikwad@nvidia.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] clk: tegra: PLLE spread spectrum control
Message-ID: <20131003153519.GT3973@tbergstrom-lnx.Nvidia.com>
References: <1380209654-25458-1-git-send-email-pdeschrijver@nvidia.com>
 <524B28EA.40702@wwwdotorg.org>
 <20131003105228.GK3973@tbergstrom-lnx.Nvidia.com>
 <524D8C0B.90707@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <524D8C0B.90707@wwwdotorg.org>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 03, 2013 at 05:23:55PM +0200, Stephen Warren wrote:
> On 10/03/2013 04:52 AM, Peter De Schrijver wrote:
> > On Tue, Oct 01, 2013 at 09:56:26PM +0200, Stephen Warren wrote:
> >> On 09/26/2013 09:34 AM, Peter De Schrijver wrote:
> >>> Add spread spectrum control for PLLE in Tegra114.
> >>
> >> It would be useful to have some description of the end-user-visible
> >> benefit of this change; why is it useful?
> > 
> > spread spectrum clocking is a technique to reduce EMI caused by the clock
> > signal by modulating the frequency with a low frequency signal. This should
> > reduce interference with eg. Wifi or cellular modems on the same board.
> 
> Great. The intent of my request was for that information to be included
> in the patch description.
> 

Mike,

Do you want a version 2 for this?

Cheers,

Peter.
