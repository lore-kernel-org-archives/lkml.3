Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754828Ab3BKJwH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 04:52:07 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:10894 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754345Ab3BKJwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 04:52:06 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Mon, 11 Feb 2013 01:52:05 -0800
Date: Mon, 11 Feb 2013 11:52:02 +0200
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "Stephen Warren" <swarren@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        "Prashant Gaikwad" <pgaikwad@nvidia.com>,
        Joseph Lo <josephl@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] clk: tegra: No 7.1 super clk dividers on Tegra20
Message-ID: <20130211095202.GY3073@tbergstrom-lnx.Nvidia.com>
References: <1360327453-29242-1-git-send-email-pdeschrijver@nvidia.com>
 <5115381F.9000308@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <5115381F.9000308@wwwdotorg.org>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 08, 2013 at 06:38:39PM +0100, Stephen Warren wrote:
> On 02/08/2013 05:44 AM, Peter De Schrijver wrote:
> > Unlike Tegra30, Tegra20 does not have a 7.1 divider for the CPU superclk.
> > Remove the clocks related to the divider.
> 
> I assume there's no particular need to take this for 3.9; it can wait
> until 3.10?

No. There isn't. These clocks aren't used yet because we don't have CPU DVFS.

Cheers,

Peter.
