Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934493Ab3CTJka (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 05:40:30 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:9568 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755959Ab3CTJk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 05:40:26 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 20 Mar 2013 02:33:08 -0700
Date: Wed, 20 Mar 2013 11:40:18 +0200
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Mike Turquette <mturquette@linaro.org>
CC: "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "Stephen Warren" <swarren@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] clk: add table lookup to mux
Message-ID: <20130320094018.GF18519@tbergstrom-lnx.Nvidia.com>
References: <1363113747-6572-1-git-send-email-pdeschrijver@nvidia.com>
 <20130319213309.8663.17375@quantum>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20130319213309.8663.17375@quantum>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 19, 2013 at 10:33:09PM +0100, Mike Turquette wrote:
> Quoting Peter De Schrijver (2013-03-12 11:42:23)
> > Add a table lookup feature to the mux clock. Also allow arbitrary masks
> > instead of the width. This will be used by some clocks on Tegra114. Also
> > adapt the tegra periph clk because it uses struct clk_mux directly.
> >
> > Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
> 
> Do you actually need arbitrary masks instead of a continuous bitfield?
> Or does this change just make it easier for you to convert existing
> data?
> 

Yes we need arbitrary masks. We have some clocks where some bits of the mux
are at the bottom of a 32bit register and other bits are at the top.

Cheers,

Peter.
