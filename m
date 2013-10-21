Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752946Ab3JUIjb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 04:39:31 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:8840 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752810Ab3JUIj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 04:39:29 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 21 Oct 2013 01:34:51 -0700
Date: Mon, 21 Oct 2013 11:39:19 +0300
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Thierry Reding <thierry.reding@gmail.com>,
        Hiroshi Doyu <hdoyu@nvidia.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 01/15] ARM: tegra30: add missing CLK IDs
Message-ID: <20131021083919.GE25591@tbergstrom-lnx.Nvidia.com>
References: <1382102719-5531-1-git-send-email-pdeschrijver@nvidia.com>
 <1382102719-5531-2-git-send-email-pdeschrijver@nvidia.com>
 <52644BBF.2050704@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <52644BBF.2050704@wwwdotorg.org>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 20, 2013 at 11:31:43PM +0200, Stephen Warren wrote:
> On 10/18/2013 02:25 PM, Peter De Schrijver wrote:
> > The Tegra30 clock bindings lack few IDs for audio and clk_out muxes.
> 
> Is there a list of changes for V5?
> 

Yes. See 'Changes since v4' maybe I should give it a different title next
time...

> Don't forget that I gave tested-by/acked-by for V4(?), unless you've
> changed so much you consider that to no longer apply?

No. Nothing major.
