Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933047AbaE3NMb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 09:12:31 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:19956 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932923AbaE3NMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 09:12:30 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 30 May 2014 06:05:15 -0700
Date: Fri, 30 May 2014 16:12:26 +0300
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 0/2] debugfs entries for Tegra clocks
Message-ID: <20140530131226.GR5961@tbergstrom-lnx.Nvidia.com>
References: <1401295868-18697-1-git-send-email-pdeschrijver@nvidia.com>
 <538773C0.30906@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <538773C0.30906@wwwdotorg.org>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 07:52:00PM +0200, Stephen Warren wrote:
> On 05/28/2014 10:51 AM, Peter De Schrijver wrote:
> > This patch set introduces the 'regs' debugfs entry which shows the
> > contents of all registers related to a clock.
> 
> Would it be better to create a regmap object for the entire clock module
> register space, and then get all the debugfs stuff for free?

Maybe. You wouldn't get the register names though.

Cheers,

Peter.
