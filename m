Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754430Ab3CVMPT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 08:15:19 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:15145 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186Ab3CVMPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 08:15:15 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 22 Mar 2013 05:15:06 -0700
Date: Fri, 22 Mar 2013 14:15:07 +0200
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH REPOST v2] clk: add table lookup to mux
Message-ID: <20130322121507.GX18519@tbergstrom-lnx.Nvidia.com>
References: <1363954078-29952-1-git-send-email-pdeschrijver@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1363954078-29952-1-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 22, 2013 at 01:07:53PM +0100, Peter De Schrijver wrote:
> Add a table lookup feature to the mux clock. Also allow arbitrary masks
> instead of the width. This will be used by some clocks on Tegra114. Also
> adapt the tegra periph clk because it uses struct clk_mux directly.
> 
> Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>

This is actually the first post, despite the subject.

Thanks,

Peter.
